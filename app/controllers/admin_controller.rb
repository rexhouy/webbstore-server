# -*- coding: utf-8 -*-
class AdminController < ApplicationController

        # Authenticate users using devise
        # before_action :authenticate_user!

        # Load menu info
        before_action :menu

        def menu
                @menus = [{:url => "/admin/products", :text => "产品", :class => ""},
                          {:url => "/admin/orders", :text => "订单", :class => ""}]
                @menus.each do |menu|
                        menu[:class] = "active" if menu[:url].eql? "/#{params[:controller]}"
                end
        end

end
