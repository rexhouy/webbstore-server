class Api::ProductsController < ApiController

        def index
                @channel = params[:channel]
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

        def organic
                session[:channel] = "organic"
                @products = Product.owner(owner).organic.available.valid.paginate(:page => params[:page])
                render json: @products
        end

        def custom
                session[:channel] = "custom"
                @products = Product.owner(owner).custom.available.valid.paginate(:page => params[:page])
                render json: @products
        end

        private
        def owner
                Rails.application.config.owner
        end

end
