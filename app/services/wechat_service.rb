# -*- coding: utf-8 -*-
require "rubygems"
require "json"
require 'active_support/core_ext'

class WechatService

        # WECHAT = Config::PAYMENT["weixin"]

        def pay(order, client_ip, code)
                Rails.logger.debug "Start handle wechat payment, client_ip: #{client_ip}, code: #{code}"
                open_id = get_open_id(code)
                prepay_id = get_prepay_id(order, client_ip, open_id)
                gen_result(prepay_id)
        end

        private
        def get_open_id(code)
                http = Net::HTTP.new(WECHAT["access_token"]["host"], WECHAT["access_token"]["port"])
                http.use_ssl = true
                http.set_debug_output(Rails.logger)
                req = Net::HTTP::Get.new(WECHAT["access_token"]["path"] + "?" + get_open_id_params(code))
                resp = http.request(req)
                Rails.logger.debug "Get prepay id response: #{resp.body}"
                JSON.parse(resp.body)["openid"]
        end

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

        def get_prepay_id(order, client_ip, open_id)
                http = Net::HTTP.new(WECHAT["prepay"]["host"], WECHAT["prepay"]["port"])
                http.use_ssl = true
                http.set_debug_output(Rails.logger)
                req = Net::HTTP::Post.new(WECHAT["prepay"]["path"])
                req.body = prepay_id_request_param(order, client_ip, open_id)
                resp = http.request(req)
                Rails.logger.debug "Get prepay id response: #{resp.body}"
                resp_xml = Hash.from_xml(resp.body.gsub("\n", ""))
                return resp_xml["xml"]["prepay_id"] if "SUCCESS".eql? resp_xml["xml"]["return_code"].upcase
                nil
        end

        def prepay_id_request_param(order, client_ip, open_id)
                params = {
                        appid: WECHAT["appid"].to_s,
                        mch_id: WECHAT["mch_id"].to_s,
                        nonce_str: Random::DEFAULT.rand(10 ** 16).to_s,
                        body: order.detail,
                        out_trade_no: order.order_id,
                        total_fee: (order.subtotal * 100).to_i.to_s,
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
                Rail.logger.debug "JSAPI params: #{params}"
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


end
