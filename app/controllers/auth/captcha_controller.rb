require "securerandom"
class Auth::CaptchaController < ApplicationController

        def index
                captcha = Captcha.find_by_tel(params[:tel])
                captcha ||= Captcha.new
                captcha.tel = params[:tel]
                captcha.register_token = SecureRandom.random_number(10**6).to_s.rjust(6,"0")
                captcha.register_sent_at = DateTime.now + 10.minutes # Expire in 10 minutes

                SmsService.new.send_captcha(captcha.register_token, captcha.tel)

                captcha.save
                render text: "ok".html_safe
        end

end
