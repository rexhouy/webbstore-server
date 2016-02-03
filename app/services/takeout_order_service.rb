class TakeoutOrderService < OrderService

        def create(cart, payment_type, memo, user_coupon, use_account_balance, address_id, current_user)
                @order = TakeoutOrder.new
                set_address(address_id)
                @order.seller_id = Rails.application.config.owner
                super(cart, payment_type, memo, user_coupon, use_account_balance, current_user)
        end

        private
        def set_address(address_id)
                address = Address.find(address_id)
                @order.contact_name = address.name
                @order.contact_tel = address.tel
                @order.contact_address = address.state + address.city + address.street
        end

end
