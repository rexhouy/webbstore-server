class Api::PaymentsController < ApiController

        def front_notify
                if valid? [:funcode, :appId, :mhtOrderNo, :mhtCharset, :tradeStatus, :mhtReserved, :transStatus]
                        update_order_status(params[:mhtOrderNo])
                        @success = true
                end
                render layout: false
        end

        def notify
                if valid? [:funcode, :appId, :mhtOrderNo, :mhtCharset, :tradeStatus, :mhtReserved, :transStatus]
                        update_order_status(params[:mhtOrderNo])
                        render plain: "success=Y"
                else
                        render plain: "success=N"
                end
        end

        def wechat_notify
                result = request.body.read
                logger.debug "Notification received from wechat: #{result}"
                resp_xml = Hash.from_xml(result.gsub("\n", ""))
                if "SUCCESS".eql? resp_xml["xml"]["return_code"].upcase
                        order_id = resp_xml['xml']['out_trade_no']
                        logger.info "Payment succeed [#{order_id}]."
                        update_order_status(order_id)
                else
                        logger.warn "Payment result: failed. #{resp_xml['xml']['return_msg']}"
                end
                render plain: "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>"
        end

        def result
                @order_id = params[:id]
                @success = params[:success].eql? "true"
                render layout: false
        end

        private
        def update_order_status(order_id)
                order = Order.find_by_order_id(order_id)
                logger.error "Order not found #{order_id}" if order.nil?
                return order.update(status: Order.statuses[:paid]) if order.placed?
                logger.error "Update order status to paid has failed. Order status incorrect. order id [#{order.order_id}], status [#{order.status}]"
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

end
