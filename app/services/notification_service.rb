# -*- coding: utf-8 -*-
require "rubygems"
require "json"
require 'active_support/core_ext'

class NotificationService

	WECHAT = Config::PAYMENT["weixin"]
	WECHAT_NOTIFY = WECHAT["notify"]

	def send_order_notify(order, user)
		Rails.logger.debug "Send order notification to user #{user.id}, order: #{order.id}"
		WechatService.new.send_notification(order, user, data(order, user))
	end

	private
	def data(order, user)
		{
			touser: user.wechat_openid,
			template_id: WECHAT_NOTIFY["order_template_id"],
			url:"http://#{Rails.application.config.domain}/admin/orders/#{order.id}",
			topcolor: WECHAT_NOTIFY["topcolor"],
			data: {
				first: {
					value: "有用户下单",
					color: WECHAT_NOTIFY["fontcolor"]
				},
				keyword1:{
					value: "拾惠社",
					color: WECHAT_NOTIFY["fontcolor"]
				},
				keyword2: {
					value: order.detail,
					color: WECHAT_NOTIFY["fontcolor"]
				},
				keyword3: {
					value: order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
					color: WECHAT_NOTIFY["fontcolor"]
				},
				keyword4: {
					value: order.subtotal,
					color: WECHAT_NOTIFY["fontcolor"]
				},
				keyword5: {
					value: "已支付",
					color: WECHAT_NOTIFY["fontcolor"]
				},
				remark:{
					value: "",
					color: WECHAT_NOTIFY["fontcolor"]
				}
			}
		}.to_json
	end

end
