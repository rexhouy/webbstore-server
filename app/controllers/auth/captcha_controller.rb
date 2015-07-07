class Auth::CaptchaController < ApplicationController

        def index
                captcha = Captcha.find_by_tel(params[:tel])
                captcha ||= Captcha.new
                captcha.tel = params[:tel]
                captcha.register_token = "123456"
                captcha.register_sent_at = DateTime.now + 10.minutes # Expire in 10 minutes
                captcha.save
                render text: "ok".html_safe
        end

end
