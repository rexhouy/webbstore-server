require "json"
class PaymentsController < ApiController

        def wechat_redirect
                code = params[:code]
                open_id = params[:open_id]
                @order_id = params[:state]
                @wechat_params = WechatService.new.pay(Order.find(@order_id), request.remote_ip, open_id, code, current_user)
                render layout: false
        end

        def alipay_redirect
                order = Order.find(params[:id])
                @order_id = params[:id]
                @url = Config::PAYMENT["alipay"]["mobile_pay"]["url"].clone
                @url << "?" << AlipayService.new.pay(order).to_query
                render layout: false
        end

        def wechat_notify
                result = request.body.read
                logger.debug "Notification received from wechat: #{result}"
                resp_xml = Hash.from_xml(result.gsub("\n", ""))
                if "SUCCESS".eql? resp_xml["xml"]["return_code"].upcase
                        order_id = resp_xml['xml']['out_trade_no']
                        logger.info "Payment succeed [#{order_id}]."
                        OrderService.new.payment_succeed(order_id, resp_xml["xml"].to_json)
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
                        OrderService.new.payment_succeed(params[:out_trade_no], params.to_json)
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
