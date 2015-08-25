class MeController < ApiController

        before_action :authenticate_user!

        def index
        end

end
