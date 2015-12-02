# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
        # Prevent CSRF attacks by raising an exception.
        # For APIs, you may want to use :null_session instead.
        protect_from_forgery with: :exception
        skip_before_action :verify_authenticity_token, if: :skip_forgery_protection?

        WillPaginate.per_page = 20

        # Channels used in menu
        before_action do
                @channels = Channel.owner(Rails.application.config.owner).order(priority: :desc)
        end

        before_filter :store_location

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
                        session[:previous_url] = request.fullpath
                end
        end

        # Devise redirect
        def after_sign_in_path_for(resource)
                session[:previous_url] || root_path
        end

        def skip_forgery_protection?
                [
                 {controller: "payments", action: "wechat_notify"},
                 {controller: "payments", action: "alipay_notify"}
                ].any? do |p|
                        params[:controller].eql? p[:controller] and action_name.eql? p[:action]
                end
        end

        include SimpleCaptcha::ControllerHelpers

        ## Devise strong parameters
        before_filter :configure_permitted_parameters, if: :devise_controller?
        def configure_permitted_parameters
                devise_parameter_sanitizer.for(:account_update) { |u|
                        u.permit(:password, :password_confirmation, :current_password)
                }
        end

        def render_404
                raise ActionController::RoutingError.new("Not Found")
        end

        def get_cart_products_detail(cart)
                result = {}
                cart.values.each do |product|
                        p = product.clone
                        p["detail"] = Product.find(product["id"])
                        p["spec"] = Specification.find(product["spec_id"]) unless product["spec_id"].blank?
                        result["#{product['id']}_#{product['spec_id']}"] = p
                end
                result
        end

        def cart_price(cart)
                cart.values.reduce(0) do |memo, product|
                        memo += product_price(product)
                end
        end

        def cart_count(cart)
                cart.values.reduce(0) do |memo, product|
                        memo += product["count"].to_i
                end
        end

        def product_price(product)
                product["count"].to_f * unit_price(product)
        end

        def unit_price(product)
                (product["spec"].nil?) ? product["detail"].price.to_f : product["spec"].price.to_f
        end

end
