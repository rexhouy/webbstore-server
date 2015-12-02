class AddReserveTimeToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :reserve_time, :datetime
                add_index :orders, :type
        end
end
