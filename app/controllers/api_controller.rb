# -*- coding: utf-8 -*-
class ApiController < ApplicationController

        WillPaginate.per_page = 10

        def get_cart
                session[:cart] || []
        end

        def clear_cart
                session[:cart] = []
        end


        ## Use the html page to redirect user instead of 403 response. Use this method to redirect user to a brand new login page, instead of return a partial.
        def auth_user
                render("/api/to_login", layout: false) unless user_signed_in?
        end

end
