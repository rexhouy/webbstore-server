class AddPriceRangeToProducts < ActiveRecord::Migration
        def change
                add_column :products, :min_price, :decimal, precision: 8, scale: 2
                add_column :products, :max_price, :decimal, precision: 8, scale: 2
                add_column :products, :start_date, :datetime
        end
end
