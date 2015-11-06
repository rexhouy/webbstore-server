# -*- coding: utf-8 -*-
require "securerandom"

class OrdersController < ApiController

        before_action :authenticate_user!

        def index
                @type = params[:type] || "all"
                @orders = Order.where(customer: current_user).owner(Rails.application.config.owner).type(@type).order(id: :desc).paginate(page: params[:page])
        end

        def show
                @order = Order.find(params[:id])
                return render_404 unless @order.customer_id.eql? current_user.id
                @url = payment_redirect_url(@order)
        end

        def wechat_pay
                code = params[:code]
                open_id = params[:open_id]
                @order_id = params[:state]
                @wechat_params = WechatService.new.pay(Order.find(@order_id), request.remote_ip, open_id, code, current_user)
                render layout: false
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
                        order = OrderService.new.create(get_cart, params[:paymentType], params[:memo],
                                                params[:use_coupon], params[:use_account_balance].eql?("true"), params[:addressId], current_user)
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
        def alipay(order)
                return AlipayService.new.pay(order)
        end

        def validate
                if get_cart.empty?
                        @errors ||= []
                        @errors << "购物车里没有商品"
                        return false
                end
                true
        end

        def payment_redirect_url(order)
                return "/orders/#{order.id}" if order.paid?
                url = ""
                if order.alipay?
                        url = Config::PAYMENT["alipay"]["mobile_pay"]["url"].clone
                        url << "?" << alipay(order).to_query
                elsif order.wechat?
                        if current_user.wechat_openid.present?
                                url = "http://#{Rails.application.config.domain}/orders/payment/wechat_redirect?open_id=#{current_user.wechat_openid}&state=#{order.id}"
                        else
                                url = WechatService.new.auth_url("http://#{Rails.application.config.domain}/orders/payment/wechat_redirect", order.id)
                        end
                elsif order.offline_pay?
                        url = "/orders/#{order.id}"
                end
                url
        end

end
