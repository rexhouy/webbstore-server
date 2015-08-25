class Auth::SessionsController < Devise::SessionsController
        # before_filter :configure_sign_in_params, only: [:create]

        # GET /resource/sign_in
        # def new
        #   super
        # end

        # POST /resource/sign_in
        def create
                super
                flash.discard # discard flash messages after this session
        end

        # DELETE /resource/sign_out
        def destroy
                super
                flash.discard # discard flash messages after this session
        end

        # protected

        # You can put the params you want to permit in the empty array.
        # def configure_sign_in_params
        #   devise_parameter_sanitizer.for(:sign_in) << :attribute
        # end
end
