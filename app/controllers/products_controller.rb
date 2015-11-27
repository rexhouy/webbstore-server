# -*- coding: utf-8 -*-
class ProductsController < ApiController

        def order
                session[:type] = "order"
                @title = "订桌订餐"
                index
        end

        def takeout
                session[:type]= "takeout"
                @title = "外卖点餐"
                index
        end

        def index
                category_id = params[:category]
                @category = Category.find_by_id(category_id) unless category_id.eql? "recommendation"
                if @category.present? && @category.group_id.eql?(owner)
                        session[:category] = @category
                else
                        @category = nil
                        category_id = "recommendation"
                end
                respond_to do |format|
                        format.html {
                                @submenu = get_submenu(category_id)
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
                @title = "订桌订餐" if session[:type].eql?("order")
                @title = "外卖点餐" if session[:type].eql?("takeout")
                @back_url = "/"
        end
        def get_submenu(selected_category)
                menus = [{
                                 name: "推荐",
                                 href: "/products?category=recommendation",
                                 class: "recommendation".eql?(selected_category) ? "highlight-icon" : ""
                         }]
                Category.owner(owner).root.each do |category|
                        menus << {
                                name: category.name,
                                href: "/products?category=#{category.id}",
                                class: category.id.eql?(selected_category) ? "highlight-icon" : ""
                        }
                end
                menus
        end

end
