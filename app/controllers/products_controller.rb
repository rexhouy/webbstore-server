# -*- coding: utf-8 -*-
class ProductsController < ApiController

        def index
                return redirect_to root_url if !takeout? && !menu?
                @title = takeout? ? "外卖点餐" : "店内点餐"
                @back_url = root_url
                category_id = params[:category]
                @category = Category.find_by_id(category_id) unless category_id.eql? "recommendation"
                if @category.present? && @category.group_id.eql?(owner)
                        session[:category] = @category
                else
                        @category = ""
                        category_id = "recommendation"
                end
                respond_to do |format|
                        format.html {
                                @submenu = get_submenu(category_id)
                                @recommendProducts = []#Product.owner(owner).category(@category).recommend.order(priority: :desc)
                                @cart_count = cart_count(get_cart)
                                render :index
                        }
                        format.json {
                                @products = Product.owner(owner).category(@category).channel(session[:channel_id]).available.valid.order(priority: :desc).paginate(page: params[:page])
                                @cart = get_cart
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
                @title = takeout? ? "外卖点餐" : "店内点餐"
                @search_text = params[:search_text]
                products = Product.search_by_owner(@search_text, owner)

                # Filter products by channel && set product count
                @products =[]
                cart = get_cart
                products.each do |product|
                        next if menu? && !is_menu?(product)
                        next if takeout? && !is_takeout_menu?(product)
                        specs = []
                        product.specifications.each do |spec|
                                cart_spec_p = cart["#{product.id}_#{spec.id}"]
                                specs << {spec: spec, count: cart_spec_p.present? ? cart_spec_p["count"] : 0}
                        end
                        cart_spec_p = cart["#{product.id}_"]
                        @products << {product: product, stars: product.stars, count: cart_spec_p.present? ? cart_spec_p["count"] : 0, specs: specs}
                end
                @cart_count = cart_count(get_cart)
                @back_url = "javascript:window.history.back()"
        end

        private
        def is_takeout_menu?(product)
                product.channels.any? do |channel|
                        channel.id.eql? 2
                end
        end

        def is_menu?(product)
                product.channels.any? do |channel|
                        channel.id.eql? 3
                end
        end

        def owner
                Rails.application.config.owner
        end
        def set_header
                @title = "外卖点餐" if takeout?
                @title = "点餐" if menu?
                @back_url = "/"
        end
        def get_submenu(selected_category)
                menus = [{
                                 name: "推荐",
                                 href: "/products?category=recommendation",
                                 class: "recommendation".eql?(selected_category) ? "active" : ""
                         }]
                Channel.find(session["channel_id"]).categories.each do |category|
                        menus << {
                                name: category.name,
                                href: "/products?category=#{category.id}",
                                class: category.id.eql?(selected_category.to_i) ? "active" : ""
                        }
                end
                menus
        end

end
