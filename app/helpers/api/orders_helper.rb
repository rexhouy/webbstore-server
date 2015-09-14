# -*- coding: utf-8 -*-
module Api::OrdersHelper

        def order_status(order)
                if order.placed? && !order.offline_pay?
                        return "等待付款"
                elsif order.paid?
                        return "已付款"
                elsif (order.placed? && order.offline_pay?) || order.paid?
                        return "待处理"
                elsif order.shipping?
                        return "已发货"
                elsif order.delivered?
                        return "已处理"
                elsif order.canceled?
                        return "已取消"
                else
                        return "未知"
                end
        end

        def need_online_pay?(order)
                order.placed? && !order.offline_pay?
        end

        def is_cancelable?(order)
                order.placed?
        end

        def payment_name(order)
                return "微信支付" if order.wechat?
                return "支付宝" if order.alipay?
                return "货到付款" if order.offline_pay?
        end

        def type_name(order)
                return "外卖" if order.takeout?
                "订餐"
        end

end
