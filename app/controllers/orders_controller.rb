# -*- coding: utf-8 -*-
require "securerandom"

class OrdersController < ApiController

        before_action :authenticate_user!

        def index
                @orders = Order.where(customer: current_user).owner(session[:shop_id]).order(id: :desc).paginate(page: params[:page])
        end

        def show
                @order = Order.find(params[:id])
                @url = payment_redirect_url(@order)
                if @order.paid?
                        url = "http://#{Rails.application.config.domain}/order/#{@order.id}/print"
                        @qr_code = RQRCode::QRCode.new(url, size: 12, level: :m )
                end
                @back_url = "/orders"
        end

        def confirm
                return redirect_to :carts if get_cart.empty?
                @cart = get_cart_products_detail(get_cart)
                @user = current_user
                @address = Address.new
                @user_coupons = UserCoupon.joins(:coupon)
                        .where(user_id: current_user.id, status: UserCoupon.statuses[:unused])
                        .where("coupons.end_date > now()")
                        .where("coupons.limit <= ?", cart_price(@cart))
                @title = "购买"
                render :confirm
        end

        def add
                unless validate
                        flash.now["info"] = "购物失败"
                        flash.now["errors"] = @errors
                        confirm
                        return
                end
                begin
                        order = OrderService.new.create_anonymous(get_cart, session[:shop_id], session[:table_id], params[:payment_type], current_user)
                        clear_cart
                        redirect_to payment_redirect_url(order)
                rescue => e
                        logger.error e
                        logger.error e.backtrace.join("\n")
                        flash.now["info"] = "购物失败"
                        flash.now["errors"] = [ e ]
                        confirm
                end
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
        def set_header
                @title = "订单"
                @back_url = "/#{session[:shop_id]}"
        end

        def validate
                if get_cart.empty?
                        @errors ||= []
                        @errors << "购物车里没有商品"
                        return false
                end
                true
        end

        ## Redirect to a view and let the view handle the payment.
        def payment_redirect_url(order)
                return "/orders/#{order.id}" if order.paid? || order.offline_pay?
                return "http://#{Rails.application.config.domain}/payment/alipay/redirect?id=#{order.id}" if order.alipay?
                if order.wechat?
                        return WechatService.new.auth_url("http://#{Rails.application.config.domain}/payment/wechat/redirect", order.id)
                end
                render_404
        end

end
