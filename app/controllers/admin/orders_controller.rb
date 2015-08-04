# -*- coding: utf-8 -*-
class Admin::OrdersController < AdminController

        load_and_authorize_resource

        def index
                @order_id = params[:order_id] || ""
                if @order_id.empty?
                        @type = params[:type] || "wait_shipping"
                        @orders = Order.type(@type).paginate(:page => params[:page])
                else
                        @orders = Order.where(order_id: @order_id).paginate(:page => params[:page])
                end
        end

        def show
                @order = Order.find(params[:id])
        end

        def cancel
                change_status Order.statuses[:canceled]
        end

        def shipping
                change_status Order.statuses[:shipping]
        end

        def deliver
                change_status Order.statuses[:delivered]
        end

        ## 到注册监听页面，提示用户使用微信扫描二维码，注册订单监听。（获取用户openid）
        def notification
                url = WechatService.new.auth_url("http://www.tenhs.com/admin/orders/wechat_register_notification/#{current_user.id}", "")
                @qr_code = RQRCode::QRCode.new(url, size: 12, level: :m )
        end

        ## 用户注册订单监听回调，
        def wechat_register_notification
                code = params[:code]
                openid = WechatService.new.get_open_id(code)
                # Save open id to user set order notification to true
                user = User.get(params[:uid])
                user.update(wechat_openid: openid, order_notification: true)
        end

        private
        def change_status(status)
                @order = Order.find(params[:id])
                @order.status = status
                @order.save
                redirect_to [:admin, @order]
        end

end
