class MeController < ApiController

        before_action :authenticate_user!

        def index
        end

        def introduce
                @introduced_users = User.where(introducer: current_user.id).paginate(page: params[:page])
                url = "http://#{Rails.application.config.domain}/users/sign_up?introducer_token=#{current_user.introducer_token}"
                @qr_code = RQRCode::QRCode.new(url, size: 12, level: :m )
        end

        def coupons
                @user_coupons = UserCoupon.where(user_id: current_user.id, status: UserCoupon.statuses[:unused])
        end

        def wallet
                @account_balance_histories = AccountBalanceHistory.owner(current_user.id).order(id: :desc).paginate(page: params[:page])
        end

end
