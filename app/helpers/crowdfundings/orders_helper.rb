# -*- coding: utf-8 -*-
module Crowdfundings::OrdersHelper


        def crowdfunding_status(crowdfunding)
                return "<span class='text-success'>众筹成功</span>".html_safe if crowdfunding.succeed?
                return "<span class='text-danger'>众筹失败</span>".html_safe if crowdfunding.failed?
                "众筹将于#{display_date_zh crowdfunding.end_date}结束"
        end

        def payment_status(order)
                return "已支付定金" if order.paid?
                return "未支付" if order.placed?
                return "已全额付款" if order.crowdfunding_paid?
                return "订单已取消" if order.canceled?
        end

        def payment_name(order)
                return "微信支付" if order.wechat?
                return "支付宝" if order.alipay?
                return "货到付款" if order.offline_pay?
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

end
