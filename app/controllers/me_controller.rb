class MeController < ApiController

        before_action :authenticate_user!

        def index
        end

        def introduce
                @introduced_users = User.where(introducer: current_user.id).paginate(page: params[:page])
                url = "http://#{Rails.application.config.domain}/users/sign_up?introducer_token=#{current_user.introducer_token}"
                @qr_code = RQRCode::QRCode.new(url, size: 12, level: :m )
        end

end
