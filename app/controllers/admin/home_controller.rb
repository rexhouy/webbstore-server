class Admin::HomeController < AdminController

        def index
                render :unauthorized_access if current_user.customer?
        end

        def unauthorized_access
        end

end
