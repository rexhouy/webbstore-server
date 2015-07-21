# -*- coding: utf-8 -*-
require "securerandom"
class Auth::CaptchaController < ApplicationController

        def index
                return render(text: "图形验证码不正确") unless check_photo_captcha
                captcha = Captcha.find_by_tel(params[:tel])
                captcha ||= Captcha.new
                captcha.tel = params[:tel]
                captcha.register_token = SecureRandom.random_number(10**6).to_s.rjust(6,"0")
                captcha.register_sent_at = DateTime.now + 10.minutes # Expire in 10 minutes

                SmsService.new.send_captcha(captcha.register_token, captcha.tel, params[:template_id])

                captcha.save
                render text: "ok".html_safe
        end

        private

        def check_photo_captcha
                simple_captcha_valid?
        end

end
