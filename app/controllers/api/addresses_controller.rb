class Api::AddressesController < ApiController

        before_action :auth_user

        def index
                @addresses = current_user.addresses
                @address = Address.new
                render layout: false
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
                                data: render_to_string(partial: "/api/addresses/item", object: address),
                                id: address.id}
                else
                        render json: {success: false}
                end
        end

        def destroy
                address = Address.find(params[:id])
                if address and address.user.id.eql? current_user.id
                        address.update(status: Address.statuses[:disabled])
                        render json: {success: true,
                                id: address.id}
                else
                        render json: {success: false}
                end
        end

        def create
                @address = Address.new(address_params)
                @address.user = current_user
                result = {};
                if @address.save
                        result[:success] = true
                        result[:data] = render_to_string partial: "/api/addresses/item", object: @address
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


end
