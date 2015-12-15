# -*- coding: utf-8 -*-
class Admin::OrdersController < AdminController
        # Checks authorization for all actions using cancan
        authorize_resource
        before_action :set_order, only: [:show, :cancel, :shipping, :deliver]

        def index
                @order_id_or_tel = params[:order_id] || ""
                @order_date = params[:order_date] || ""
                if @order_id.blank? && @order_date.blank?
                        @orders = Order.owner(owner).order(id: :desc).paginate(page: params[:page])
                else
                        @orders = Order.search(@order_id, @order_date).owner(owner).order(id: :desc).paginate(page: params[:page])
                end
        end

        def show
        end

        def cancel
                begin
                        OrderService.new.cancel(@order, current_user)
                rescue => e
                        logger.error e
                        logger.error e.backtrace.join("\n")
                        return redirect_to admin_order_path(@order), notice: e.to_s
                end
                redirect_to admin_order_path(@order), notice: "修改成功"
        end

        def shipping
                OrderService.new.change_status(@order, Order.statuses[:shipping], current_user.id)
                NotificationService.new.send_order_delivery_notify(@order, @order.customer)
                redirect_to admin_order_path(@order), notice: "修改成功"
        end

        def deliver
                OrderService.new.change_status(@order, Order.statuses[:delivered], current_user.id)
                redirect_to admin_order_path(@order), notice: "修改成功"
        end

        ## 到注册监听页面，提示用户使用微信扫描二维码，注册订单监听。（获取用户openid）
        def notification
                url = "http://#{Rails.application.config.domain}/admin/orders/notification_redirect/wechat"
                @qr_code = RQRCode::QRCode.new(url, size: 12, level: :m )
                @notification_users = User.owner(owner).where(order_notification: true).where("wechat_openid is not null")
        end

        def notification_redirect_page
                redirect_to WechatService.new.auth_url("http://#{Rails.application.config.domain}/admin/orders/wechat_register_notification/#{current_user.id}", "")
        end

        ## 用户注册订单监听回调，
        def wechat_register_notification
                code = params[:code]
                logger.debug "register notification callback, received code #{code}, user #{params[:uid]}"
                openid = WechatService.new.get_open_id(code)
                unless openid.present?
                        logger.error "Register notification failed fro user #{params[:uid]}, get openid has failed."
                        @error = "获取openid失败"
                        return
                end
                # Save open id to user set order notification to true
                user = User.find(params[:uid])
                if user.customer?
                        @error = "您没有权限进行该操作"
                        return
                end
                user.update(wechat_openid: openid, order_notification: true)
                logger.info "Register notification success for user #{user.id}, openid: #{openid}"
        end

        def cards
                @type = params[:type] || "all"
                if @type.eql? "all"
                        @cards = Card.where(status: Card.statuses[:open]).where("remain > 0").paginate(page: params[:page])
                else
                        @cards = Card.where(next: date_of_next("Wednesday")).where("remain > 0").paginate(page: params[:page])
                end
        end

        def card
                @card = Card.find(params[:id])
                respond_to do |format|
                        format.html {  }
                        format.json { render json: @card }
                end
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
        def search_or_list(clazz)
        end
        def set_order
                @order = Order.find(params[:id])
                render_404 unless @order.seller_id.eql? owner
        end
        def date_of_next(day)
                date  = Date.parse(day)
                delta = date > Date.today ? 0 : 7
                date + delta
        end

end
