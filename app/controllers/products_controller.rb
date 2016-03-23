# -*- coding: utf-8 -*-
class ProductsController < ApiController

        def index
                @title = "生态食品"
                session[:is_bulk] = false
                list(false)
        end

        def bulk
                @title = "大宗采购"
                session[:is_bulk] = true
                list(true)
        end

        def list(is_bulk)
                category_id = params[:category]
                @category = Category.find_by_id(category_id)
                @category = nil unless @category.present? && @category.group_id.eql?(owner)
                session[:category] = @category.present? ? @category.id : nil
                respond_to do |format|
                        format.html {
                                set_submenu(@category)
                                @recommendProducts = []
                                render :index
                        }
                        format.json {
                                @products = Product.owner(owner).category(@category).is_bulk(is_bulk).available.valid.order(priority: :desc).paginate(page: params[:page])
                                render :index
                        }
                end
        end

        def show
                @product = Product.find(params[:id])
                authenticate_user! if @product.is_bulk
                @title = "商品详情"
                if @product.is_bulk
                        @back_url = "/bulk?category=#{session[:category]}"
                else
                        @back_url = "/products?category=#{session[:category]}"
                end
        end

        def search
                @search_text = params[:search_text]
                @products = Product.search_by_owner(@search_text, owner, session[:is_bulk])
                @back_url =session[:is_bulk] ? "/bulk?category=#{session[:category]}" : "/products?category=#{session[:category]}"
        end

        def price_hist
                respond_to do |format|
                        format.html {
                        }
                        format.json {
                                @product = Product.find(params[:id])
                                @hists = ProductPriceHistory.where(product_id: params[:id], start_date: @product.start_date).order(id: :asc)
                                @hists = @hists.map do |hist|
                                        {
                                                time: hist.created_at,
                                                price_km: hist.price_km,
                                                price_bj: hist.price_bj
                                        }
                                end
                                @hists << {
                                        time: Time.current,
                                        price_km: @hists[-1][:price_km],
                                        price_bj: @hists[-1][:price_bj]
                                } if @hists.any?
                        }
                end
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
