# -*- coding: utf-8 -*-
class Admin::ProductsController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource
        before_action :set_product, only: [:show, :edit, :update, :destroy, :supplement]

        def index
                @search_text = params[:search_text]
                if @search_text.present?
                        @products = Product.search_by_owner(@search_text, owner)
                else
                        @products = Product.owner(owner).available.paginate(page: params[:page])
                end
                @out_of_stock_products = Product.owner(owner).available.out_of_stock unless params[:page].present?
        end

        def edit
        end

        def update
                Product.transaction do
                        destroyed_specs(@product.specifications).each do |spec|
                                spec.update(status: Specification.statuses[:disabled])
                        end
                        if @product.update(product_params)
                                redirect_to admin_product_path(@product), notice: "更新成功"
                        else
                                render "edit"
                        end
                end
        end

        def new
                @product = Product.new

        end

        def show
        end

        def create
                @product = Product.new(product_params)
                @product.owner_id = owner
                if @product.save
                        redirect_to admin_product_path(@product), notice: "创建成功"
                else
                        render "new"
                end
        end

        def preview
                @product = Product.new(preview_params)
                render "/products/show", layout: "application"
        end

        def destroy
                @product.update(status: Product.statuses[:disabled], on_sale: false)
                redirect_to admin_products_path, notice: "删除成功"
        end

        def supplement
                count = params[:count].to_i
                Product.transaction do
                        if params[:spec_id].present?
                                spec = Specification.find(params[:spec_id])
                                spec.update(storage: spec.storage+count)
                        end
                        @product.update(storage: @product.storage+count)
                end
                redirect_to admin_product_path(@product), notice: "补货完成"
        end

        private
        def set_product
                @product = Product.find(params[:id])
                render_404 unless @product.owner_id.eql?  owner
        end

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
                params.require(:product).permit(:id, :name, :price, :storage, :description, :article, :recommend, :on_sale, :cover_image, :category_id, :priority, :supplier_id,
                                                specifications_attributes: [:id, :name, :value, :price, :storage, :count])
        end

        def preview_params
                params.require(:product).permit(:name, :price, :storage, :description, :article, :recommend, :cover_image, :category_id)
        end

end
