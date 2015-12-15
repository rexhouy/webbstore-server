# -*- coding: utf-8 -*-
module Admin::OrdersHelper

        def order_status(order)
                return "等待付款" if order.placed?
                return "已付款" if order.paid?
                return "已打印小票" if order.printed?
                return "已完成" if order.delivered?
                return "已取消" if order.canceled?
        end

        def reserve_order_status(order)
                return "已取消" if order.canceled?
                return "正常"
        end

        def order_history_status(history)
                return "创建" if history.placed?
                return "支付完成" if history.paid?
                return "发货" if history.shipping?
                return "订单完成" if history.delivered?
                return "订单取消" if history.canceled?
                "未知"
        end

        def order_status_change_operator(history)
                return "系统" if history.operator.nil?
                history.operator.tel
        end

        def order_payment(order)
                return "微信支付" if order.wechat?
                return "支付宝" if order.alipay?
                return "货到付款" if order.offline_pay?
        end

        def payment_status(order)
                return "已支付" if order.paid? || order.shipping? || order.delivered?
                return "已取消" if order.canceled?
                "未支付"
        end

end
