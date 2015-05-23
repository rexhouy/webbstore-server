class ChangeSubtotalTypeInOrders < ActiveRecord::Migration
        def change
                change_column :orders, :subtotal, :decimal, precision: 2, scale: 10
        end
end
