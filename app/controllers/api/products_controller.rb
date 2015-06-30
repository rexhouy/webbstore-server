class Api::ProductsController < ApiController

        def index
                @recommendProducts = Product.owner(owner).recommend.available.valid.all
                render layout: false
        end

        def show
                @product = Product.find(params[:id])
                render layout: false
        end

        def search
                @search_text = params[:text]
                @products = Product.owner(owner).search(@search_text)
                render layout: false
        end

        def all
                products = Product.owner(owner).available.valid.paginate(:page => params[:page])
                render json: products
        end

        private
        def owner
                Rails.application.config.owner
        end

end
