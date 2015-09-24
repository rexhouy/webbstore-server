class AddDeliveryTypeToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :delivery_type, :integer
        end
end
