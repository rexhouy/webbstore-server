# -*- coding: utf-8 -*-
class Crowdfundings::ProductsController < CrowdfundingsController

        before_action :authenticate_user!, only: :buy

        def index
                respond_to do |format|
                        format.html {
                                render :index
                        }
                        format.json {
                                @products = Product.wholesale.owner(owner).category(@category).available.valid.order(priority: :desc).paginate(page: params[:page])
                        }
                end
        end

        def show
                @product = Product.find(params[:id])
                @title = "商品详情"
                @back_url = "/crowdfundings/products"
        end

        def buy
                @product = Product.find(params[:id])
                @title = "购买商品"
                @back_url = crowdfundings_products_detail_url(@product)
        end

        private
        def owner
                Rails.application.config.owner
        end
        def set_header
        end
end
