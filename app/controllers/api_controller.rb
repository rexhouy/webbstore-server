# -*- coding: utf-8 -*-
class ApiController < ApplicationController

        WillPaginate.per_page = 20

        def get_cart
                session[:cart] || []
        end

        def clear_cart
                session[:cart] = []
        end

end
