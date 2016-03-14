class AddSalesToProductPriceHistories < ActiveRecord::Migration
        def change
                add_column :product_price_histories, :sales_km, :integer
                add_column :product_price_histories, :sales_bj, :integer
        end
end
