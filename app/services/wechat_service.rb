# -*- coding: utf-8 -*-
require "rubygems"
require "json"
require 'active_support/core_ext'

class WechatService

        WECHAT = Config::PAYMENT["weixin"]
        WECHAT_NOTIFY = WECHAT["notify"]

        def pay(order, client_ip, open_id, code, user, fee)
                Rails.logger.debug "Start handle wechat payment, client_ip: #{client_ip}, code: #{code}"
                open_id ||= get_open_id(code)
                user.update(wechat_openid: open_id)
                prepay_id = get_prepay_id(order, client_ip, open_id, fee)
                gen_result(prepay_id)
        end

        def auth_url(redirect_url, state)
                params = {
                        appid: Config::PAYMENT["weixin"]["appid"],
                        redirect_uri: redirect_url,
                        response_type: "code",
                        scope: "snsapi_base",
                        state: state
                }
                "https://open.weixin.qq.com/connect/oauth2/authorize?" << params.to_query << "#wechat_redirect"
        end

        def get_open_id(code)
                http = Net::HTTP.new(WECHAT["auth_access_token"]["host"], WECHAT["auth_access_token"]["port"])
                http.use_ssl = true
                http.set_debug_output(Rails.logger)
                req = Net::HTTP::Get.new(WECHAT["auth_access_token"]["path"] + "?" + get_open_id_params(code))
                resp = http.request(req)
                Rails.logger.debug "Get prepay id response: #{resp.body}"
                JSON.parse(resp.body)["openid"]
        end

        def send_notification(order, user, data)
                Rails.logger.info "Send notification to #{user.id}, order #{order.id}"
                path = "#{WECHAT_NOTIFY['path']}?access_token=#{get_access_token}"
                http = Net::HTTP.new(WECHAT_NOTIFY["host"], WECHAT_NOTIFY["port"])
                http.use_ssl = true
                http.set_debug_output(Rails.logger)
                req = Net::HTTP::Post.new(path)
                req.body = data
                resp = http.request(req)
                Rails.logger.info "Send notification response #{resp.inspect}"
        end

        private
        def get_open_id_params(code)
                {
                        appid: WECHAT["appid"],
                        secret: WECHAT["appsecret"],
                        code: code,
                        grant_type: "authorization_code"
                }.collect { |k, v|
                        "#{k}=#{v}"
                }.join("&")
        end

        def get_prepay_id(order, client_ip, open_id, fee)
                http = Net::HTTP.new(WECHAT["prepay"]["host"], WECHAT["prepay"]["port"])
                http.use_ssl = true
                http.set_debug_output(Rails.logger)
                req = Net::HTTP::Post.new(WECHAT["prepay"]["path"])
                req.body = prepay_id_request_param(order, client_ip, open_id, fee)
                resp = http.request(req)
                Rails.logger.debug "Get prepay id response: #{resp.body}"
                resp_xml = Hash.from_xml(resp.body.gsub("\n", ""))
                return resp_xml["xml"]["prepay_id"] if "SUCCESS".eql? resp_xml["xml"]["return_code"].upcase
                nil
        end

        def prepay_id_request_param(order, client_ip, open_id, fee)
                fee = (fee * 100).to_i.to_s if fee
                params = {
                        appid: WECHAT["appid"].to_s,
                        mch_id: WECHAT["mch_id"].to_s,
                        nonce_str: Random::DEFAULT.rand(10 ** 16).to_s,
                        body: order.name[0..30],
                        detail: order.detail,
                        out_trade_no: out_trade_no(order),
                        total_fee: fee || ((order.subtotal - order.coupon_amount - order.user_account_balance) * 100).to_i.to_s,
                        spbill_create_ip: client_ip,
                        notify_url: WECHAT["notify_url"],
                        trade_type: "JSAPI",
                        openid: open_id
                }
                params[:sign] = sign(params)
                xml_params = params.to_xml(root: "xml", dasherize: false)
                Rails.logger.debug "Prepay request params: #{xml_params}"
                xml_params
        end

        def gen_result(prepay_id)
                # "appId" : "wx2421b1c4370ec43b",     //公众号名称，由商户传入
                # "timeStamp":" 1395712654",         //时间戳，自1970年以来的秒数
                # "nonceStr" : "e61463f8efa94090b1f366cccfbbb444", //随机串
                # "package" : "prepay_id=u802345jgfjsdfgsdg888",
                # "signType" : "MD5",         //微信签名方式:
                # "paySign" : "70EA570631E4BB79628FBCA90534C63FF7FADD89" //微信签名
                params = {
                        appId: WECHAT["appid"],
                        timeStamp: Time.now.to_i,
                        nonceStr: Random::DEFAULT.rand(10 ** 16),
                        package: "prepay_id=#{prepay_id}",
                        signType: "MD5",
                }
                params[:paySign] = sign(params)
                Rails.logger.debug "JSAPI params: #{params}"
                params
        end

        # Exclude blank param
        def sign(params)
                sign_param = params.keys.sort.reduce("") do |param_string, key|
                        value = params[key]
                        is_empty_field = (value.nil? or (value.is_a?(String) and value.strip.empty?))
                        param_string << "#{key}=#{value}&" unless is_empty_field
                        param_string
                end
                sign_param << "key=#{WECHAT['prepay']['api_secret']}"
                Rails.logger.debug "Sign param: #{sign_param}"
                value = md5(sign_param).upcase
                Rails.logger.debug "Signature: #{value}"
                value
        end

        def md5(value)
                Digest::MD5.new.update(value.encode("utf-8")).hexdigest
        end

        def get_access_token
                http = Net::HTTP.new(WECHAT["access_token"]["host"], WECHAT["access_token"]["port"])
                http.set_debug_output(Rails.logger)
                req = Net::HTTP::Get.new(WECHAT["access_token"]["path"])
                resp = http.request(req)
                Rails.logger.debug "Get access_token response: #{resp.body}"
                JSON.parse(resp.body)["token"]
        end

        def out_trade_no(order)
                return order.order_id + "x" if order.is_crowdfunding && order.paid?
                order.order_id
        end

end
