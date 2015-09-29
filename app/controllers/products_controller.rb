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
                                @recommendProducts = []#Product.owner(owner).category(@category).recommend.order(priority: :desc)
                                render :index
                        }
                        format.json {
                                @products = Product.owner(owner).category(@category).available.valid.order(priority: :desc).paginate(:page => params[:page])
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
