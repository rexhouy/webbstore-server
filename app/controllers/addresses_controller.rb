# -*- coding: utf-8 -*-
class AddressesController < ApiController

        before_action :authenticate_user!

        def index
                @addresses = current_user.addresses
                @address = Address.new
        end

        def show
                @address = Address.find(params[:id])
                render json: @address
        end

        def update
                address = Address.find(params[:id])
                if address and address.update(address_params)
                        render json: {
                                success: true,
                                data: address,
                                id: address.id}
                else
                        render json: {success: false}
                end
        end

        def destroy
                address = Address.find(params[:id])
                if address && address.user.id.eql?(current_user.id)
                        address.update(status: Address.statuses[:disabled])
                end
                respond_to do |format|
                        format.html { redirect_to :addresses, notice: "删除成功" }
                        format.json { render json: {success: true} }
                end
        end

        def create
                @address = Address.new(address_params)
                @address.user = current_user
                result = {};
                if @address.save
                        result[:success] = true
                        result[:data] = render_to_string partial: "/addresses/item", object: @address
                        result[:id] = @address.id
                else
                        result[:success] = false
                end
                render json: result
        end

        private
        def address_params
                params.require(:address).permit(:id, :name, :state, :city, :street, :tel)
        end
        def set_header
                @title = "地址管理"
                @back_url = "/me"
        end


end
