class AddSimpleOrderNoToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :simple_order_no, :integer
        end
end
