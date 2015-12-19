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
                return "用户" if history.operator_id.eql?(-1)
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

        def usable_account_balance(cart)
                total_price = cart_price(cart)
                account_balance = current_user.balance
                total_price > account_balance ? account_balance : total_price
        end

        def order_name(order)
                case order.type
                when "ImmediateOrder"
                        "订单"
                when "TakeoutOrder"
                        "外卖订单"
                when "ReserveOrder"
                        "预订订单"
                end
        end

        def payment_status(order)
                return "已支付" if order.paid? || order.shipping? || order.delivered?
                return "已取消" if order.canceled?
                "未支付"
        end

        def alert_info(order)
                return "" if order.canceled? || order.delivered?
                text = %Q(<div class="alert alert-info" role="alert">)
                text << "操作提示：请点击立即支付按钮完成支付!" if order.placed?
                text << "操作提示：请到小票打印机处扫描二维码打印小票!" if order.paid?
                text << "操作提示：请将打印出来的小票交给服务员!" if order.printed?
                text << %Q(</div>)
                text.html_safe
        end

end
