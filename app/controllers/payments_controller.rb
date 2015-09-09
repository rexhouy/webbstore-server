require "json"
class PaymentsController < ApiController

        def wechat_notify
                result = request.body.read
                logger.debug "Notification received from wechat: #{result}"
                resp_xml = Hash.from_xml(result.gsub("\n", ""))
                if "SUCCESS".eql? resp_xml["xml"]["return_code"].upcase
                        order_id = resp_xml['xml']['out_trade_no']
                        logger.info "Payment succeed [#{order_id}]."
                        update_order_status(order_id, resp_xml["xml"].to_json)
                else
                        logger.warn "Payment result: failed. #{resp_xml['xml']['return_msg']}"
                end
                render plain: "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>"
        end

        def wechat_front_notify
                @order_id = params[:id]
                @success = params[:success].eql? "true"
                render "result", layout: false
        end

        def alipay_notify
                if ["TRADE_FINISHED", "TRADE_SUCCESS"].include?(params[:trade_status])
                        update_order_status(params[:out_trade_no], params.to_json)
                        logger.info "Payment succeed [#{params[:out_trade_no]}]."
                end
                render plain: "success"
        end

        def alipay_front_notify
                order = Order.find_by_order_id(params[:out_trade_no])
                @order_id = order.id
                @success = ["TRADE_FINISHED", "TRADE_SUCCESS"].include?(params[:trade_status])
                render "result", layout: false
        end

        private
        def update_order_status(order_id, payment)
                order = Order.find_by_order_id(order_id)
                logger.error "Order not found #{order_id}" if order.nil?
                if order.placed?
                        order.update(status: Order.statuses[:paid], payment: payment)
                        update_card_status(order_id)
                        send_notify_to_seller(order)
                        send_notify_to_customer(order)
                else
                        logger.error "Update order status to paid has failed. Order status incorrect. order id [#{order.order_id}], status [#{order.status}]"
                end
        end
        def update_card_status(order_id)
                Card.where(order_id: order_id).update_all(status: Card.statuses[:open], next: Date.today.next_week(:wednesday))
        end

        def valid?(valid_fields)
                SignatureService.new.check_signature(
                                                     notify_params(valid_fields),
                                                     params[:signature])
        end

        def notify_params(keys)
                valid_params = {}
                keys.each do |key|
                        valid_params[key] = params[key]
                end
                logger.debug "received notify params: #{valid_params.inspect}"
                valid_params
        end

        def send_notify_to_seller(order)
                sellers = find_notify_sellers(order.seller.id)
                sellers.each do |seller|
                        NotificationService.new.send_order_notify(order, seller)
                end
        end

        def send_notify_to_customer(order)
                if order.customer.wechat_openid.present?
                        NotificationService.new.send_order_notify_to_customer(order, order.customer)
                end
        end

        def find_notify_sellers(group_id)
                User.where(order_notification: true, group_id: group_id).all
        end

end
