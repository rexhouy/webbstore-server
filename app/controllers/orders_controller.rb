# -*- coding: utf-8 -*-
require "securerandom"

class OrdersController < ApiController

        before_action :authenticate_user!

        def index
                @type = params[:type] || "all"
                @orders = Order.where(customer: current_user).owner(Rails.application.config.owner).type(@type).order(id: :desc).paginate(page: params[:page])
                @submenu = [{name: "所有订单", class: @type.eql?("all") ? "highlight-icon" : "", href: "/orders"},
                            {name: "未完成订单", class: @type.eql?("unfinished") ? "highlight-icon" : "", href: "/orders?type=unfinished"},
                            {name: "已取消订单", class: @type.eql?("canceled") ? "highlight-icon" : "", href: "/orders?type=canceled"}]
        end

        def show
                @order = Order.find(params[:id])
                return render_404 unless @order.customer_id.eql? current_user.id
                @url = payment_redirect_url(@order)
                @back_url = "/orders"
        end

        def confirm_bulk
                @specification = Specification.find(params[:spec_id])
                @product = @specification.product
                return redirect_to "/products/#{@product.id}", notice: "拍卖尚未开始" unless @product.started?
                @back_url = "/products/#{params[:id]}"
                @order = @order || Order.new
                render :confirm_bulk
        end

        def add_bulk
                begin
                        @order = Order.new(bulk_order_params)
                        @order.contact_address = current_user.location + @order.contact_address
                        @order = BulkOrderService.new.create(params[:spec_id], @order, params[:count],
                                                             Order.payment_types[:alipay], current_user)
                        redirect_to payment_redirect_url(@order)
                rescue => e
                        logger.error e
                        logger.error e.backtrace.join("\n")
                        flash.now["info"] = e
                        confirm_bulk
                end
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

        def bulk_order_params
                params.require(:order).permit(:contact_name, :contact_tel, :contact_address, :memo)
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
