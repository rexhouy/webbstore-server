# -*- coding: utf-8 -*-
class Admin::ShopsController < AdminController
        before_action :set_shop

        # GET /admin/shops
        def show
                current_user.group
        end

        # GET /admin/shops/edit
        def edit
        end

        # PATCH/PUT /admin/shops
        # PATCH/PUT /admin/shops.json
        def update
                respond_to do |format|
                        if @shop.update(shop_params)
                                format.html { redirect_to admin_shops_url, notice: "修改成功" }
                                format.json { render :show, status: :ok, location: @shop }
                        else
                                format.html {
                                        render "edit" }
                                format.json { render json: @shop.errors, status: :unprocessable_entity }
                        end
                end
        end

        def preview
                @shop.assign_attributes(shop_params)
                render "/shops/index", layout: "application"
        end

        private
        # Use callbacks to share common setup or constraints between actions.
        def set_shop
                @shop = Shop.where(group_id: current_user.group_id).first
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def shop_params
                params.require(:shop).permit(:tel, :address, :introduce, :image)
        end
end
