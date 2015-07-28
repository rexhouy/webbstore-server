# -*- coding: utf-8 -*-
module Api::OrdersHelper

        def order_status(order)
                if order.placed?
                        return "等待付款"
                elsif order.paid?
                        return "已付款"
                elsif order.shipping?
                        return "已发货"
                elsif order.delivered?
                        return "完成"
                elsif order.canceled?
                        return "已取消"
                else
                        return "未知"
                end
        end

        def need_online_pay?(order)
                order.placed?
        end

        def is_cancelable?(order)
                order.placed? or order.paid?
        end

        def payment_name(order)
                return "微信支付" if order.wechat?
                "支付宝"
        end

end
