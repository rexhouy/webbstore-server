class AddDiscountPriceToProducts < ActiveRecord::Migration
        def change
                add_column :products, :origin_price, :decimal, precision: 8, scale: 2
                add_column :specifications, :origin_price, :decimal, precision: 8, scale: 2
        end
end
