# -*- coding: utf-8 -*-
class CategoriesController < ApiController

        def index
                @categories = Category.owner(owner).root
        end

        private
        def owner
                Rails.application.config.owner
        end
        def set_header
                @title = "商品分类"
                category = session[:category].present? ? session[:category]["id"] : 1
                @back_url = "/products?category=#{category || 1}"
        end

end
