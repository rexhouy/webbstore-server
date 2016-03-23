# -*- coding: utf-8 -*-
require "securerandom"

class OrdersController < ApiController

        before_action :authenticate_user!
        before_action :set_order, only: [:show, :confirm_payment, :cancel, :received, :add_dishes]

        def index
                @type = params[:type] || "takeout"
                if @type.eql? "takeout"
                        @orders = TakeoutOrder.where(customer: current_user).owner(Rails.application.config.owner).order(id: :desc).paginate(page: params[:page])
                else
                        @orders = ImmediateOrder.where(customer: current_user).owner(Rails.application.config.owner).order(id: :desc).paginate(page: params[:page])
                end
                @submenu = [
                            {name: "外卖订单", class: @type.eql?("takeout") ? "active" : "", href: "/orders?type=takeout"},
                            {name: "预订订单", class: "", href: "/reservations"},
                            {name: "店内消费订单", class: @type.eql?("immediate") ? "active" : "", href: "/orders?type=immediate"}]
        end

        def confirm_payment
                render_404 unless current_user.waiter?
                OrderService.new.payment_succeed(@order.order_id, "", params[:receive], params[:memo], current_user)
                redirect_to "/orders/#{@order.id}"
        end

        def show
                @url = payment_redirect_url(@order)
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

                unless (session[:add_dishes].nil?) # 处理加菜
                        order = Order.find(session[:add_dishes]["order_id"])
                        OrderService.new.add_dishes(order,  get_cart, current_user)
                        clear_cart
                        return cancel_add_dishes
                end

                begin
                        if takeout?
                                order = TakeoutOrderService.new.create(get_cart,
                                                                       params[:paymentType],
                                                                       params[:memo],
                                                                       params[:use_coupon],
                                                                       params[:use_account_balance].eql?("true"),
                                                                       params[:addressId],
                                                                       current_user)
                        elsif menu?
                                order = ImmediateOrderService.new.create(get_cart,
                                                                         params[:paymentType],
                                                                         params[:use_coupon],
                                                                         params[:use_account_balance].eql?("true"),
                                                                         session[:dinning_table_id] || params[:dinning_table_id],
                                                                         session[:shop_id] || Rails.application.config.owner,
                                                                         current_user)
                        end
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

        def cancel_add_dishes
                order_id = session[:add_dishes]["order_id"]
                session[:add_dishes] = nil
                redirect_to "/orders/#{order_id}"
        end

        def add_dishes
                session[:add_dishes] = {
                        order_id: @order.id,
                        time: Time.current
                }
                redirect_to products_url
        end

        def cancel
                begin
                        OrderService.new.cancel(@order, current_user)
                rescue => error
                        Rails.logger.error error
                        flash[error] = [@errors]
                end
                redirect_to action: "show", id: @order.id
        end

        def received
                OrderService.new.change_status(@order, Order.statuses[:delivered], current_user.id)
                redirect_to action: "show", id: @order.id
        end

        private
        def set_header
                @title = "订单"
                @back_url = "/carts"
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
                return "https://#{Rails.application.config.domain}/payment/alipay/redirect?id=#{order.id}" if order.alipay?
                if order.wechat?
                        if current_user.wechat_openid.present?
                                return "https://#{Rails.application.config.domain}/payment/wechat/redirect?open_id=#{current_user.wechat_openid}&state=#{order.id}"
                        end
                        return WechatService.new.auth_url("https://#{Rails.application.config.domain}/payment/wechat/redirect", order.id)
                end
                render_404
        end

        def set_order
                @order = Order.find(params[:id])
                render_404 unless @order.customer_id.eql? current_user.id
        end

end
