# -*- coding: utf-8 -*-
module Admin::OrdersHelper

        def crowdfunding_status(crowdfunding)
                return "众筹成功" if crowdfunding.succeed?
                return "众筹失败" if crowdfunding.failed?
                "众筹将于#{display_date_zh crowdfunding.end_date}结束"
        end

        def payment_status(order)
                return "已支付定金" if order.paid?
                return "未支付" if order.placed?
                return "已全额付款" if order.crowdfunding_paid?
                return "订单已取消" if order.canceled?
        end

        def order_status(order)
                return "等待付款" if order.placed? && !order.offline_pay?
                return "等待发货" if (order.placed? && order.offline_pay?) || order.paid?
                return "等待收货" if order.shipping?
                return "已完成" if order.delivered?
                return "已取消" if order.canceled?
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

end
