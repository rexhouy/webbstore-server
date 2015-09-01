# -*- coding: utf-8 -*-
require "rubygems"
require "json"
require 'active_support/core_ext'

class NotificationService

	WECHAT = Config::PAYMENT["weixin"]
	WECHAT_NOTIFY = WECHAT["notify"]

	def send_order_notify_to_customer(order, user)
		Rails.logger.debug "Send order notification to customer #{user.id}, order: #{order.id}"
		WechatService.new.send_notification(order, user, order_created_notify_data(order, user, WECHAT_NOTIFY["order_created_template_id"]))
	end

	def send_order_notify(order, user)
		Rails.logger.debug "Send order notification to admin #{user.id}, order: #{order.id}"
		WechatService.new.send_notification(order, user, new_order_notify_data(order, user, WECHAT_NOTIFY["order_template_id"]))
	end

	private
	def data(order, user, data, template_id)
		{
			touser: user.wechat_openid,
			template_id: template_id,
			url:"http://#{Rails.application.config.domain}/admin/orders/#{order.id}",
			topcolor: WECHAT_NOTIFY["topcolor"],
			data: data
		}.to_json
	end

	def order_created_notify_data(order, user, template_id)
		refundno = order.orders_products.inject do |sum, op|
			sum + op.count
		end
		d = {
			first: {
				value: "您的订单已创建成功",
				color: WECHAT_NOTIFY["fontcolor"]
			},
			orderno: {
				value: order.order_id,
				color: WECHAT_NOTIFY["fontcolor"]
			},
			refundno: {
				value: refundno,
				color: WECHAT_NOTIFY["fontcolor"]
			},
			refundproduct: {
				value: order.subtotal,
				color: WECHAT_NOTIFY["fontcolor"]
			},
			remark: {
				value: "",
				color: WECHAT_NOTIFY["fontcolor"]
			}
		}
		data(order, user, d, template_id)
	end
	
	def new_order_notify_data(order, user, template_id)
		d = {
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
		data(order, user, d, template_id)
	end

end
