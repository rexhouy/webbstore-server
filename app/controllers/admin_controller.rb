# -*- coding: utf-8 -*-
class AdminController < ApplicationController

        # Authenticate users using devise
        before_action :auth_user

        # Checks authorization for all actions using cancan
        check_authorization :unless => :public_resources?

        # Load menu info
        before_action :menu

        def public_resources?
                devise_controller? or  ["unauthorized_access", "welcome"].include?(controller_name) or skip_auth?
        end

        def skip_auth?
                [
                 {controller: "admin/orders", action: "wechat_register_notification"},
                ].any? do |p|
                        params[:controller].eql? p[:controller] and action_name.eql? p[:action]
                end
        end

        def auth_user
                redirect_to :user_session  unless user_signed_in? or skip_auth?
                unless public_resources?
                        redirect_to :admin_unauthorized_access if current_user.customer?
                end
        end

        def menu
                @menus = [{url: admin_products_url, text: "产品", class: "", resource: Product },
                          {url: admin_orders_url, text: "订单", class: "", resource: Order },
                          {url: admin_users_url, text: "用户", class: "", resource: User },
                          {url: admin_groups_url, text: "机构", class: "", resource: Group },]
                @menus.select! do |menu|
                        menu[:class] = "active" if menu[:url].end_with? controller_name
                        can? :manage, menu[:resource]
                end
        end

        rescue_from CanCan::AccessDenied do |exception|
                redirect_to :admin_unauthorized_access
        end

end
