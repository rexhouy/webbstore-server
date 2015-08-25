class ProductsController < ApiController

        def index
                @channel = params[:channel]
                session[:channel] = @channel
                respond_to do |format|
                        format.html {
                                @recommendProducts = []
                                render :index
                        }
                        format.json {
                                @products = Product.owner(owner).channel(@channel).available.valid.order(priority: :desc).paginate(:page => params[:page])
                                render json: @products
                        }
                end
        end

        def show
                @product = Product.find(params[:id])
        end

        def search
                @search_text = params[:search_text]
                @products = Product.search(@search_text).records.select do |p|
                        p.owner_id.eql? owner
                end
        end

        private
        def owner
                Rails.application.config.owner
        end

end
