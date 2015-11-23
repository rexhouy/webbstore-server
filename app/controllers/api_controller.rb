# -*- coding: utf-8 -*-
class ApiController < ApplicationController

        before_action :set_header

        def get_cart
                session[:cart] || []
        end

        def clear_cart
                session[:cart] = []
        end

        private
        def set_header
        end

end
