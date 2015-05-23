class ChangePriceType < ActiveRecord::Migration
        def change
                change_column :orders, :subtotal, :decimal, precision: 10, scale: 2
                change_column :products, :price, :decimal, precision: 10, scale: 2
                change_column :orders_products, :price, :decimal, precision: 10, scale: 2
        end
end
