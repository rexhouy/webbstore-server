# -*- coding: utf-8 -*-
class Admin::DinningTablesController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create
        before_action :set_table, only: [:show, :edit, :update, :destroy, :qrcode]

        # GET /admin/tables
        # GET /admin/tables.json
        def index
                @tables = DinningTable.where(group_id: current_user.group_id).order(table_no: :asc).paginate(page: params[:page])
        end

        # GET /admin/tables/1
        # GET /admin/tables/1.json
        def show
        end

        # GET /admin/tables/new
        def new
                @table = DinningTable.new
        end

        # GET /admin/tables/1/edit
        def edit
        end

        # POST /admin/tables
        # POST /admin/tables.json
        def create
                @table = DinningTable.new(table_params)
                @table.group_id = current_user.group_id

                respond_to do |format|
                        if @table.save
                                format.html { redirect_to admin_dinning_tables_url, notice: "创建成功！" }
                                format.json { render :show, status: :created, location: @table }
                        else
                                format.html { render :new }
                                format.json { render json: @table.errors, status: :unprocessable_entity }
                        end
                end
        end

        # PATCH/PUT /admin/tables/1
        # PATCH/PUT /admin/tables/1.json
        def update
                respond_to do |format|
                        if @table.update(table_params)
                                format.html { redirect_to admin_dinning_tables_url, notice: "修改成功！" }
                                format.json { render :show, status: :ok, location: @table }
                        else
                                format.html { render :edit }
                                format.json { render json: @table.errors, status: :unprocessable_entity }
                        end
                end
        end

        # DELETE /admin/tables/1
        # DELETE /admin/tables/1.json
        def destroy
                @table.destroy
                respond_to do |format|
                        format.html { redirect_to tables_url, notice: 'Table was successfully destroyed.' }
                        format.json { head :no_content }
                end
        end

        def print_qrcodes
	        @qrcodes = DinningTable.owner(current_user.group_id).select(:table_no).distinct.order(table_no: :asc).map do |dinning_table|
		        url = "http://#{Rails.application.config.domain}/menu/#{current_user.group_id}/tables/#{dinning_table.table_no}"
		        {qrcode: RQRCode::QRCode.new(url, size: 12, level: :m ), id: dinning_table.table_no}
	        end
	        render layout: false
        end


        private
        # Use callbacks to share common setup or constraints between actions.
        def set_table
	        @table = DinningTable.where(id: params[:id], group_id: current_user.group_id).first
                render_404 if @table.nil?
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def table_params
                params.require(:dinning_table).permit(:table_no, :size)
        end
end
