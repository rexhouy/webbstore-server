# -*- coding: utf-8 -*-
class ApiController < ApplicationController

        before_action :set_header

        def get_cart
                session[:cart] || {}
        end

        def clear_cart
                session[:cart] = {}
        end

        def menu_type
                session[:type] = "menu"
                session[:channel_id] = 3
        end

        def takeout_type
                session[:type] = "takeout"
                session[:channel_id] = 2
        end

        def takeout?
                session[:type].eql? "takeout"
        end

        def menu?
                session[:type].eql? "menu"
        end


        private
        def set_header
        end

end
