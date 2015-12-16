# -*- coding: utf-8 -*-
class ProductsController < ApiController

        def index
                category_id = params[:category]
                @category = Category.find_by_id(category_id)
                if @category.present? && @category.group_id.eql?(owner)
                        session[:category] = @category
                else
                        @category = nil
                end
                respond_to do |format|
                        format.html {
                                set_submenu(@category)
                                @recommendProducts = []#Product.owner(owner).category(@category).recommend.order(priority: :desc)
                                render :index
                        }
                        format.json {
                                @products = Product.owner(owner).category(@category).available.valid.order(priority: :desc).paginate(page: params[:page])
                                render json: @products
                        }
                end
        end

        def show
                @product = Product.find(params[:id])
                @title = "商品详情"
                category = session[:category].present? ? session[:category]["id"] : 1
                @back_url = "/products?category=#{category || 1}"
        end

        def search
                @search_text = params[:search_text]
                @products = Product.search_by_owner(@search_text, owner)
        end

        private
        def owner
                Rails.application.config.owner
        end
        def set_header
        end
        def set_submenu(active)
                @submenu = []
                Category.owner(Rails.application.config.owner).each do |category|
                        class_name = (active && active.id.eql?(category.id)) ? "highlight-icon" : ""
                        @submenu << {name: category.name, class: class_name, href: "/products?category=#{category.id}"}
                end
        end

end
