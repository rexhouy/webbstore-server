require "rubygems"
require "json"
require 'active_support/core_ext'

class AlipayService

        ALIPAY = Config::PAYMENT["alipay"]
        MOBILE_PAY = ALIPAY["mobile_pay"]

        def pay(order)
                params = {
                        service: MOBILE_PAY["service"],
                        partner: ALIPAY["pid"],
                        _input_charset: "utf-8",
                        notify_url: MOBILE_PAY["notify_url"],
                        return_url: MOBILE_PAY["return_url"],
                        out_trade_no: order.order_id,
                        subject: order.name,
                        total_fee: sprintf("%0.2f", order.subtotal),
                        seller_id: ALIPAY["seller_id"],
                        payment_type: MOBILE_PAY["payment_type"],
                        body: order.detail
                }
                params[:sign] = sign(params)
                params[:sign_type] = "MD5"
                params
        end

        private
        def sign(params)
                sign_param = params.keys.sort.reduce("") do |param_string, key|
                        value = params[key]
                        is_empty_field = (value.nil? or (value.is_a?(String) and value.strip.empty?))
                        param_string << "#{key}=#{value}&" unless is_empty_field
                        param_string
                end
                sign_param = sign_param[0...-1] << ALIPAY['key']
                Rails.logger.debug "Sign param: #{sign_param}"
                value = md5(sign_param)
                Rails.logger.debug "Signature: #{value}"
                value
        end

        def md5(value)
                Digest::MD5.new.update(value.encode("utf-8")).hexdigest
        end

end
