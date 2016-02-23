class Crowdfundings::UsersController < CrowdfundingsController

        before_action :authenticate_user!

        def set_location
                current_user.update(location: params[:location])
                render json: {location: params[:location]}
        end

end
