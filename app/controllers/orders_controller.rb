# -*- coding: utf-8 -*-
require "securerandom"

class OrdersController < ApiController

        before_action :authenticate_user!

        def index
                @type = params[:type] || "takeout"
                if @type.eql? "takeout"
                        @orders = TakeoutOrder.where(customer: current_user).owner(Rails.application.config.owner).order(id: :desc).paginate(page: params[:page])
                else
                        @orders = ImmediateOrder.where(customer: current_user).owner(Rails.application.config.owner).order(id: :desc).paginate(page: params[:page])
                end
                @submenu = [
                            {name: "外卖订单", class: @type.eql?("takeout") ? "highlight-icon" : "", href: "/orders?type=takeout"},
                            {name: "预订订单", class: "", href: "/reservations"},
                            {name: "店内消费订单", class: @type.eql?("immediate") ? "highlight-icon" : "", href: "/orders?type=immediate"}]
        end

        def show
                @order = Order.find(params[:id])
                return render_404 unless @order.customer_id.eql? current_user.id
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
                begin
                        if reserve?
                                date = DateTime.strptime(params[:date] + params[:time], "%Y-%m-%d%H:%M")
                                order = ReserveOrderService.new.create(get_cart,
                                                                       params[:paymentType],
                                                                       params[:memo],
                                                                       params[:use_coupon],
                                                                       params[:use_account_balance].eql?("true"),
                                                                       params[:count],
                                                                       date,
                                                                       params[:contact_tel],
                                                                       params[:contact_name],
                                                                       current_user)
                        elsif takeout?
                                order = TakeoutOrderService.new.create(get_cart,
                                                                       params[:paymentType],
                                                                       params[:memo],
                                                                       params[:use_coupon],
                                                                       params[:use_account_balance].eql?("true"),
                                                                       params[:addressId],
                                                                       current_user)
                        elsif immediate?
                                order = ImmediateOrderService.new.create(get_cart,
                                                                       params[:paymentType],
                                                                       params[:use_coupon],
                                                                       params[:use_account_balance].eql?("true"),
                                                                       session[:dinning_table_id],
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

end
