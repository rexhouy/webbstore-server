class AddPrintIndexToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :print_index, :string
        end
end
