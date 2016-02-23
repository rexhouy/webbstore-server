# -*- coding: utf-8 -*-
class Crowdfundings::OrdersController < CrowdfundingsController

        def create
                begin
                        order = CrowdfundingOrderService.new.create(params[:id], params[:count], params[:contact_address],
                                                                    params[:contact_name], params[:contact_tel], params[:payment_type], current_user)
                        redirect_to payment_redirect_url(order)
                rescue => e
                        logger.error e
                        logger.error e.backtrace.join("\n")
                        flash["info"] = "购物失败"
                        flash["errors"] = [ e ]
                        redirect_to "/crowdfundings/products/#{params[:id]}/buy"
                end
        end

        def index
                @orders = Order.where(customer: current_user).owner(Rails.application.config.owner).crowdfunding
                        .order(status: :asc, id: :desc).paginate(page: params[:page])
                @title = "订单信息"
                @back_url = "/crowdfundings/products"
        end

        def show
                @order = Order.find(params[:id])
                return render_404 unless @order.customer_id.eql? current_user.id
                @crowdfunding = @order.orders_products[0].product.crowdfunding
                @url = payment_redirect_url(@order)
                @title = "订单详情"
                @back_url = "/crowdfundings/orders"
        end

        def cancel
                begin
                        order = Order.find(params[:id])
                        OrderService.new.cancel(order, current_user)
                rescue => error
                        Rails.logger.error error
                        flash[error] = [@errors]
                end
                redirect_to action: "show", id: order.id
        end

        private
        ## Redirect to a view and let the view handle the payment.
        def payment_redirect_url(order)
                return "https://#{Rails.application.config.domain}/payment/alipay/redirect?id=#{order.id}" if order.alipay?
                if order.wechat?
                        if current_user.wechat_openid.present?
                                return "https://#{Rails.application.config.domain}/payment/wechat/redirect?open_id=#{current_user.wechat_openid}&state=#{order.id}"
                        end
                        return WechatService.new.auth_url("https://#{Rails.application.config.domain}/payment/wechat/redirect", order.id)
                end
                render_404
        end


end
