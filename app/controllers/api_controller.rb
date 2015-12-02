# -*- coding: utf-8 -*-
class ApiController < ApplicationController

        before_action :set_header

        def get_cart
                session[:cart] || {}
        end

        def clear_cart
                session[:cart] = {}
        end

        def order_type(type)
                session[:type] = type
        end

        def reserve?
                session[:type].eql? "reserve"
        end

        def takeout?
                session[:type].eql? "takeout"
        end

        def immediate?
                session[:type].eql? "immediate"
        end


        private
        def set_header
        end

end
