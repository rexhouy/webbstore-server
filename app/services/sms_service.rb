require 'net/http'
require 'json'
require 'base64'
require 'digest/md5'

class SmsService

        HOST = Config::SMS["host"]
        PORT = Config::SMS["port"]
        URL = Config::SMS["url"]
        AUTH_TOKEN = Config::SMS["auth_token"]
        APP_ID = Config::SMS["app_id"]
        ACCOUNT_ID = Config::SMS["account_id"]

        def send_captcha(captcha, tel, template_id)
                Rails.logger.info "Send CAPTCHA(#{captcha}) to #{tel}"
                time = time_stamp
                path = "#{URL}?sig=#{sig_parameter(time)}"
                http = Net::HTTP.new(HOST, PORT)
                http.use_ssl = true
                http.set_debug_output(Rails.logger)
                req = Net::HTTP::Post.new(path)
                req.body = data(tel, captcha, template_id)
                set_header(req, time)
                resp = http.request(req)
                Rails.logger.info "Send CAPTCHA response #{resp.inspect}"
        end

        private

        def time_stamp
                DateTime.now.strftime("%Y%m%d%H%M%S")
        end

        def sig_parameter(timestamp)
                Digest::MD5.hexdigest(ACCOUNT_ID + AUTH_TOKEN + timestamp)
        end

        def authorization(timestamp)
                Base64.urlsafe_encode64(ACCOUNT_ID + ":" + timestamp)
        end

        def set_header(req, timestamp)
                req["Accept"] = "application/json"
                req["Content-Type"] = "application/json;charset=utf-8"
                req["Authorization"] = authorization(timestamp)
        end

        def data(tel, captcha, template_id)
                {
                        "to": tel,
                        "appId": APP_ID,
                        "templateId": template_id,
                        "datas": [captcha]
                }.to_json
        end

end
