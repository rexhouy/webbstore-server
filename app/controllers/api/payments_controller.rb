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

        end

        private
        def update_order_status(order_id)
                order = Order.find_by_order_id(order_id)
                order.update(status: Order.statuses[:paid])
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
