require 'net/http'
require 'json'
require 'base64'
require 'digest/md5'

class SmsService

        # Class variables
        def initialize
                @@config ||= YAML.load((ERB.new File.new("#{Rails.root}/config/sms.yml").read).result)[Rails.env]
                @@host = @@config["host"]
                @@port = @@config["port"]
                @@url = @@config["url"]
                @@auth_token = @@config["auth_token"]
                @@app_id = @@config["app_id"]
                @@account_id = @@config["account_id"]
        end

        def send_captcha(captcha, tel)
                Rails.logger.info "Send CAPTCHA(#{captcha}) to #{tel}"
                time = time_stamp
                path = "#{@@url}?sig=#{sig_parameter(time)}"
                http = Net::HTTP.new(@@host, @@port)
                http.use_ssl = true
                http.set_debug_output($stdout)
                req = Net::HTTP::Post.new(path)
                req.body = data(tel, captcha)
                set_header(req, time)
                resp = http.request(req)
                Rails.logger.info "Send CAPTCHA response #{resp}"
        end

        private

        def time_stamp
                DateTime.now.strftime("%Y%m%d%H%M%S")
        end

        def sig_parameter(timestamp)
                Digest::MD5.hexdigest(@@account_id + @@auth_token + timestamp)
        end

        def authorization(timestamp)
                Base64.urlsafe_encode64(@@account_id + ":" + timestamp)
        end

        def set_header(req, timestamp)
                req["Accept"] = "application/json"
                req["Content-Type"] = "application/json;charset=utf-8"
                req["Authorization"] = authorization(timestamp)
        end

        def data(tel, captcha)
                {
                        "to": tel,
                        "appId": @@app_id,
                        "templateId": "1",
                        "datas": [captcha, "1"]
                }.to_json
        end

end
