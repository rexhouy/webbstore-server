# -*- coding: utf-8 -*-
class Admin::OrdersController < AdminController
        # Checks authorization for all actions using cancan
        authorize_resource

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
                NotificationService.new.send_order_delivery_notify(@order, @order.customer)
        end

        def deliver
                change_status Order.statuses[:delivered]
        end

        ## 到注册监听页面，提示用户使用微信扫描二维码，注册订单监听。（获取用户openid）
        def notification
                url = "http://#{Rails.application.config.domain}/admin/orders/notification_redirect/wechat"
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

        def cards
                @cards = Card.where(next: date_of_next("Wednesday")).where("remain > 0").paginate(:page => params[:page])
        end

        def card_deliver
                @card = Card.find(params[:id])
                card_history = CardHistory.new
                card_history.delivery_date = @card.next
                card_history.card = @card
                card_history.remain = @card.remain - 1
                card_history.memo = "配送"
                Card.transaction do
                        @card.update(remain: @card.remain - 1, next: @card.next.next_week(:wednesday))
                        card_history.save!
                end
                NotificationService.new.send_order_delivery_notify(@card, @card.user)
                redirect_to :admin_orders_cards, notice: "确认发货成功！"
        end

        private
        def date_of_next(day)
                date  = Date.parse(day)
                delta = date > Date.today ? 0 : 7
                date + delta
        end

        def change_status(status)
                @order = Order.find(params[:id])
                @order.status = status
                @order.save
                redirect_to [:admin, @order], notice: "修改成功"
        end

end
