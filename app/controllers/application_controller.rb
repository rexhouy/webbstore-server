# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
        # Prevent CSRF attacks by raising an exception.
        # For APIs, you may want to use :null_session instead.
        protect_from_forgery with: :exception
        skip_before_action :verify_authenticity_token, if: :skip_forgery_protection?

        def skip_forgery_protection?
                params[:controller].eql? "api/payments" and action_name.eql? "wechat_notify"
        end

        include SimpleCaptcha::ControllerHelpers

        before_action :store_location

        ## Devise strong parameters
        before_filter :configure_permitted_parameters, if: :devise_controller?
        def configure_permitted_parameters
                devise_parameter_sanitizer.for(:account_update) { |u|
                        u.permit(:password, :password_confirmation, :current_password)
                }
        end

        ## Devise login redirect path
        # after_filter :store_location
        def store_location
                # store last url - this is needed for post-login redirect to whatever the user last visited.
                return unless request.get?
                unless request.path.start_with? "/users/"
                        session[:last_location] = request.fullpath
                end
        end

end
