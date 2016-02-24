class AddReceiveToOrder < ActiveRecord::Migration
        def change
                add_column :orders, :receive, :decimal, precision: 8, scale: 2
        end
end
