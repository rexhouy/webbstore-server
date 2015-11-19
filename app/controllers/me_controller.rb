# -*- coding: utf-8 -*-
class MeController < ApiController

        before_action :authenticate_user!

        def index
        end

        def introduce
                @introduced_users = User.where(introducer: current_user.id).paginate(page: params[:page])
                url = "http://#{Rails.application.config.domain}/users/sign_up?introducer_token=#{current_user.introducer_token}"
                @qr_code = RQRCode::QRCode.new(url, size: 12, level: :m )
                @title = "推荐给好友"
                @back_url = "/me"
        end

        def coupons
                @user_coupons = UserCoupon.where(user_id: current_user.id, status: UserCoupon.statuses[:unused])
                @title = "优惠券"
                @back_url = "/me"
        end

        def wallet
                @account_balance_histories = AccountBalanceHistory.owner(current_user.id).order(id: :desc).paginate(page: params[:page])
                @title = "账户余额"
                @back_url = "/me"
        end

        private
        def set_header
                @title = "我的" + Rails.application.config.name
                @back_url = "/"
        end



end
