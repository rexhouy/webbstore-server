# -*- coding: utf-8 -*-
class Admin::SuppliersController < AdminController
        before_action :set_supplier, only: [:show, :edit, :update, :destroy]

        # GET /admin/suppliers
        # GET /admin/suppliers.json
        def index
                @suppliers = Supplier.owner(owner).paginate(page: params[:page])
        end

        # GET /admin/suppliers/1
        # GET /admin/suppliers/1.json
        def show
        end

        # GET /admin/suppliers/new
        def new
                @supplier = Supplier.new
        end

        # GET /admin/suppliers/1/edit
        def edit
        end

        # POST /admin/suppliers
        # POST /admin/suppliers.json
        def create
                @supplier = Supplier.new(supplier_params)
                @supplier.group_id = owner

                respond_to do |format|
                        if @supplier.save
                                format.html { redirect_to admin_supplier_url(@supplier), notice: "创建成功" }
                                format.json { render :show, status: :created, location: @supplier }
                        else
                                format.html { render :new }
                                format.json { render json: @supplier.errors, status: :unprocessable_entity }
                        end
                end
        end

        # PATCH/PUT /admin/suppliers/1
        # PATCH/PUT /admin/suppliers/1.json
        def update
                respond_to do |format|
                        if @supplier.update(supplier_params)
                                format.html { redirect_to admin_supplier_url(@supplier), notice: "更新成功" }
                                format.json { render :show, status: :ok, location: @supplier }
                        else
                                format.html { render :edit }
                                format.json { render json: @supplier.errors, status: :unprocessable_entity }
                        end
                end
        end

        # DELETE /admin/suppliers/1
        # DELETE /admin/suppliers/1.json
        def destroy
                @supplier.destroy
                respond_to do |format|
                        format.html { redirect_to admin_suppliers_url, notice: "删除成功" }
                        format.json { head :no_content }
                end
        end

        private
        # Use callbacks to share common setup or constraints between actions.
        def set_supplier
                @supplier = Supplier.find(params[:id])
                render_404 unless @supplier.group_id.eql?  owner
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def supplier_params
                params.require(:supplier).permit(:name)
        end

end
