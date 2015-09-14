class AddMemoToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :memo, :text
        end
end
