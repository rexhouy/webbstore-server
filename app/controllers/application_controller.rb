# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
        # Prevent CSRF attacks by raising an exception.
        # For APIs, you may want to use :null_session instead.
        protect_from_forgery with: :exception

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
                if (request.path != "/users/sign_in" &&
                    request.path != "/users/sign_up" &&
                    request.path != "/users/password/new" &&
                    request.path != "/users/password/edit" &&
                    request.path != "/users/confirmation" &&
                    request.path != "/users/sign_out" &&
                    !request.xhr?) # don't store ajax calls
                        session[:last_location] = request.fullpath
                end
        end

        ## Need to redirect user to '/xxx' instead of '/api/xxx'
        def after_sign_in_path_for(resource)
                sign_in_url = new_user_session_url
                if request.referer == sign_in_url
                        super
                else
                        last_location =  session[:last_location]
                        unless last_location.nil? or last_location.empty?
                                last_location.gsub!(/\/api\//, "/")
                        end
                        last_location || root_path
                end
        end

        def after_sign_out_path_for(resource)
                user_session_url
        end

end
