# -*- coding: utf-8 -*-
module Admin::OrdersHelper

        def order_status(order)
                return "等待付款" if order.placed? && !order.offline_pay?
                return "等待处理" if (order.placed? && order.offline_pay?) || order.paid?
                return "等待收货" if order.shipping?
                return "已完成" if order.finished?
                return "已取消" if order.canceled?
        end

        def order_payment(order)
                return "微信支付" if order.wechat?
                return "支付宝" if order.alipay?
                return "货到付款" if order.offline_pay?
        end

        def type_name(order)
                return "外卖" if order.takeout?
                "订餐"
        end

end
