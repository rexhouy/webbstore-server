class AddShippingMemoToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :shipping_memo, :text
        end
end
