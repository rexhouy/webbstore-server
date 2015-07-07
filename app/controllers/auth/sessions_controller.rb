class Auth::SessionsController < Devise::SessionsController
        # before_filter :configure_sign_in_params, only: [:create]

        # GET /resource/sign_in
        # def new
        #   super
        # end

        # POST /resource/sign_in
        # def create
        #   super
        # end

        # DELETE /resource/sign_out
        # def destroy
        #   super
        # end

        ## Need to redirect user to '/xxx' instead of '/api/xxx'
        def after_sign_in_path_for(resource)
                last_location =  session[:last_location]
                unless last_location.nil? or last_location.empty?
                        last_location = "/orders/all" if last_location.start_with?("/api/orders")
                        last_location.gsub!(/\/api\//, "/")
                end
                last_location || root_path
        end

        def after_sign_out_path_for(resource)
                user_session_url
        end


        # protected

        # You can put the params you want to permit in the empty array.
        # def configure_sign_in_params
        #   devise_parameter_sanitizer.for(:sign_in) << :attribute
        # end
end
