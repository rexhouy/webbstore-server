class AddReserveSeatsToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :reserve_seats, :integer
        end
end
