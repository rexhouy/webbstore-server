class AddIsBulkToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :is_bulk, :boolean
        end
end
