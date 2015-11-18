class ShopsController < ApiController

        before_action :set_shop

        def index
        end

        def products
                @products = Product.owner(@shop.group_id).available.valid.order(priority: :desc)
        end

        private
        def set_shop
                @shop = Shop.find(params[:id])
        end

end
