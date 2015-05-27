class Admin::ProductsController < AdminController

        load_and_authorize_resource

        def index
                @products = Product.available.paginate(:page => params[:page])
        end

        def edit
                @product = Product.find(params[:id])
        end

        def update
                @product = Product.find(params[:id])
                if @product.update(product_params)
                        redirect_to :action => "show", :id => @product.id
                else
                        render "edit"
                end
        end

        def new
                @product = Product.new
        end

        def show
                @product = Product.find(params[:id])
        end

        def create
                @product = Product.new(product_params)
                @product.owner_id = current_user.group.id
                if @product.save
                        redirect_to :action => "show", :id => @product.id
                else
                        render "new"
                end
        end

        def preview
                @product = Product.new(preview_params)
                render "/api/products/show", :layout => "application"
        end

        def destroy
                @product = Product.find(params[:id])
                @product.update(status: Product.statuses[:disabled], on_sale: false)
                redirect_to admin_products_path
        end

        private
        def product_params
                params.require(:product).permit(:id, :name, :price, :storage, :description, :article, :recommend, :on_sale, :cover_image,
                                                specifications_attributes: [:id, :name, :value, :price, :storage])
        end

        def preview_params
                params.require(:product).permit(:name, :price, :storage, :description, :article, :recommend, :cover_image)
        end

end
