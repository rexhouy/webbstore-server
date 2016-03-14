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
                                create_price_history(@product) if bulk_price_changed?(@product.previous_changes)
                                redirect_to admin_product_path(@product), notice: "更新成功"
                        else
                                render "edit"
                        end
                end
        end

        def new
                @product = Product.new
                @product.build_crowdfunding
        end

        def show
        end

        def create
                @is_wholesale = params[:is_wholesale]
                @product = Product.new(product_params)
                @product.owner_id = owner
                if @product.save
                        create_price_history(@product)
                        redirect_to admin_product_path(@product), notice: "创建成功"
                else
                        @product.build_crowdfunding if @product.crowdfunding.nil?
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
                params.require(:product).permit(:id, :name, :price, :storage, :description, :article, :recommend, :on_sale,
                                                :cover_image, :category_id, :priority, :supplier_id,
                                                :is_bulk, :batch_size, :price_km, :price_bj,
                                                specifications_attributes: [:id, :name, :value, :price, :storage, :count])
                # :is_crowdfunding,
                # crowdfunding_attributes: [:id, :threshold, :start_date, :end_date, :delivery_date, :price_km, :price_bj, :threshold_per_trade, :prepayment])
        end

        def preview_params
                params.require(:product).permit(:name, :price, :storage, :description, :article, :recommend, :cover_image, :category_id)
        end

        def create_price_history(product)
                hist = ProductPriceHistory.new
                hist.batch_size = product.batch_size
                hist.price_km = product.price_km
                hist.price_bj = product.price_bj
                hist.product_id = product.id
                hist.save!
        end

        def bulk_price_changed?(changed_attrs)
                changed_attrs["price_km"].present? || changed_attrs["batch_size"].present? || changed_attrs["price_bj"].present?
        end

end
