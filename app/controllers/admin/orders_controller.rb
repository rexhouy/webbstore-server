# -*- coding: utf-8 -*-
class Admin::OrdersController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource

        def index
                @order_id_or_tel = params[:order_id_or_tel] || ""
                @order_date = params[:order_date] || ""
                if @order_id_or_tel.blank? && @order_date.blank?
                        @type = params[:type] || "wait_shipping"
                        @orders = Order.type(@type).owner(owner).paginate(:page => params[:page])
                else
                        @orders = Order.search(@order_id_or_tel, @order_date).owner(owner).paginate(:page => params[:page])
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
                url = "http://#{Rails.application.config.domain}/admin/notifiction_redirect"
                @qr_code = RQRCode::QRCode.new(url, size: 12, level: :m )
        end

        def notification_redirect_page
                redirect_to WechatService.new.auth_url("http://#{Rails.application.config.domain}/admin/orders/wechat_register_notification/#{current_user.id}", "")
        end

        ## 用户注册订单监听回调，
        def wechat_register_notification
                code = params[:code]
                logger.debug "register notification callback, received code #{code}, user #{params[:uid]}"
                openid = WechatService.new.get_open_id(code)
                # Save open id to user set order notification to true
                user = User.find(params[:uid])
                user.update(wechat_openid: openid, order_notification: true)
                logger.info "Register notification success for user #{user.id}, openid: #{openid}"
        end

        private
        def change_status(status)
                @order = Order.find(params[:id])
                @order.status = status
                @order.save
                redirect_to [:admin, @order]
        end

end
