class Api::AddressesController < ApiController

        before_action :auth_user

        def index
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
