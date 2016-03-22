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
                        }
                end
        end

        def show
                @product = Product.find(params[:id])
                authenticate_user! if @product.is_bulk
                @title = "商品详情"
                category = session[:category].present? ? session[:category]["id"] : 1
                @back_url = "/products?category=#{category || 1}"
        end

        def search
                @search_text = params[:search_text]
                @products = Product.search_by_owner(@search_text, owner, false)
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
                                        time: Time.now,
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
