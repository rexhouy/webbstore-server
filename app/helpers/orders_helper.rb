# -*- coding: utf-8 -*-
module OrdersHelper

        def order_status(order)
                if order.placed? && !order.offline_pay?
                        return "等待付款"
                elsif order.paid?
                        return "已付款"
                elsif (order.placed? && order.offline_pay?) || order.paid?
                        return "待发货"
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

        def order_history_status(history)
                return "创建" if history.placed?
                return "支付完成" if history.paid?
                return "发货" if history.shipping?
                return "订单完成" if history.delivered?
                return "订单取消" if history.canceled?
                "未知"
        end

        def order_status_change_operator(history)
                return "系统" if history.operator_id.nil?
                return "用户" if history.operator_id.eql? current_user.id
                "管理员"
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

end
