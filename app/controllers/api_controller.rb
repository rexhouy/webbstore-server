# -*- coding: utf-8 -*-
class ApiController < ApplicationController

        def get_cart
                session[:cart] || []
        end

        def clear_cart
                session[:cart] = []
        end

end
