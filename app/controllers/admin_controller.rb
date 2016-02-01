# -*- coding: utf-8 -*-
class AdminController < ApplicationController

        # Authenticate users using devise
        before_action :auth_user
        before_filter :store_index_location

        # Load menu info
        before_action :menu

        def public_resources?
                devise_controller? ||  ["unauthorized_access", "home"].include?(controller_name)
        end

        def auth_user
                return redirect_to :user_session  unless user_signed_in?
                unless public_resources?
                        redirect_to :admin_unauthorized_access if current_user.customer?
                end
        end

        def store_index_location
                return unless request.get?
                unless (/^\/admin\/\w+$/ =~ request.path).nil?
                        session[:index_path] = request.fullpath
                end
        end

        def menu
                return if current_user.nil?
                @menus = [{url: admin_products_url, text: "商品", class: "", resource: Product },
                          {url: admin_takeout_orders_url, text: "订单", class: "", resource: Order },
                          {url: admin_trades_url, text: "交易", class: "", resource: Trade },
                          {url: admin_channels_url, text: "CMS", class: "", resource: Channel },
                          {url: admin_dinning_tables_url, text: "桌台", class: "", resource: DinningTable },
                          {url: admin_users_url, text: "用户", class: "", resource: User }]
                @menus.select! do |menu|
                        menu[:class] = "active" if menu[:url].end_with? controller_name
                        can? :read, menu[:resource]
                end
        end

        rescue_from CanCan::AccessDenied do |exception|
                logger.debug exception
                redirect_to :admin_unauthorized_access
        end

        def owner
                current_user.group_id
        end

end
