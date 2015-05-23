class Api::MeController < ApiController

        before_action :auth_user

        def index
                render layout: false
        end

end
