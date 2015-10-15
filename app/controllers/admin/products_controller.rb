class Admin::ProductsController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource

        def index
                @search_text = params[:search_text]
                if @search_text.present?
                        @products = Product.search_by_owner(@search_text, owner)
                else
                        @products = Product.owner(owner).available.paginate(:page => params[:page])
                end
        end

        def edit
                @product = Product.find(params[:id])
                @suppliers = Supplier.owner(owner).all
                return head(:forbidden) unless @product.owner_id.eql? owner
        end

        def update
                @product = Product.find(params[:id])
                return head(:forbidden) unless @product.owner_id.eql? owner
                Product.transaction do
                        destroyed_specs(@product.specifications).each do |spec|
                                spec.update(status: Specification.statuses[:disabled])
                        end
                        if @product.update(product_params)
                                redirect_to :action => "show", :id => @product.id
                        else
                                @suppliers = Supplier.owner(owner).all
                                render "edit"
                        end
                end
        end

        def new
                @product = Product.new
                @suppliers = Supplier.owner(owner).all
                @channels = Channel.owner(owner).all
        end

        def show
                @product = Product.find(params[:id])
                return head(:forbidden) unless @product.owner_id.eql? owner
        end

        def create
                @product = Product.new(product_params)
                @product.owner_id = owner
                if @product.save
                        redirect_to :action => "show", :id => @product.id
                else
                        @suppliers = Supplier.owner(owner).all
                        render "new"
                end
        end

        def preview
                @product = Product.new(preview_params)
                render "/products/show", :layout => "application"
        end

        def destroy
                @product = Product.find(params[:id])
                return head(:forbidden) unless @product.owner_id.eql? owner
                @product.update(status: Product.statuses[:disabled], on_sale: false)
                redirect_to admin_products_path
        end

        private
        def destroyed_specs(specs)
                specs ||= []
                if params[:product][:specifications_attributes].nil?
                        return specs
                end
                new_spec_ids = params[:product][:specifications_attributes].map do |p|
                        p[1][:id].to_i
                end
                specs.select do |spec|
                        !new_spec_ids.include?(spec.id)
                end
        end

        def product_params
                params.require(:product).permit(:id, :name, :price, :storage, :description, :article, :recommend, :on_sale, :cover_image,
                                                :category_id, :priority, :supplier_id, :barcode, :origin_price,
                                                specifications_attributes: [:id, :name, :value, :price, :storage, :count, :origin_price])
        end

        def preview_params
                params.require(:product).permit(:name, :price, :storage, :description, :article, :recommend, :cover_image, :category_id, :origin_price)
        end

end
