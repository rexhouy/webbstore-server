# -*- coding: utf-8 -*-
class ShopsController < ApiController

        before_action :set_shop, only: [:show, :products]

        def index
                @shops = Shop.where(status: Shop.statuses[:active]).where.not(image: nil).all
        end

        def show
        end

        def products
                @products = Product.owner(@shop.group_id).available.valid.order(priority: :desc)
        end

        private
        def set_header
                @title = "店铺"
                @back_url = "/"
        end
        def set_shop
                @shop = Shop.find(params[:id])
        end

end
