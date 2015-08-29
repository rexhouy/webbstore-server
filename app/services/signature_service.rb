# -*- coding: utf-8 -*-
require "digest"

class SignatureService

        NONE_SIGN_FIELD = ["funcode", "deviceType", "mhtSignType", "mhtSignature"]

        ## Empty fileds are not sign fields.
        def sign(params)
                sign_param = params.keys.sort.reduce("") do |param_string, key|
                        value = params[key]
                        is_empty_field = (value.nil? or (value.is_a?(String) and value.strip.empty?))
                        is_none_sign_field = NONE_SIGN_FIELD.include? key
                        param_string << "#{key}=#{value}&" unless (is_empty_field or is_none_sign_field)
                        param_string
                end
                sign_param << Config::PAYMENT_ENCRYPTED_KEY
                Rails.logger.debug "Sign param: #{sign_param}"
                value = md5 sign_param
                Rails.logger.debug "Signature: #{value}"
                value
        end

        def check_signature(params, signature)
                sign(params).eql? signature
        end

        private
        def md5(value)
                Digest::MD5.new.update(value.encode("utf-8")).hexdigest
        end

end
