class ReserveOrderService < OrderService

        def create(cart, payment_type, memo, user_coupon, use_account_balance, count, date, contact_tel, contact_name, current_user)
                @order = ReserveOrder.new
                @order.contact_name = contact_name
                @order.contact_tel = contact_tel
                @order.reserve_time = date
                @order.reserve_seats = count
                super(cart, payment_type, memo, user_coupon, use_account_balance, current_user)
        end

end
