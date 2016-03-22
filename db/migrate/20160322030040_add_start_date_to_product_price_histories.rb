class AddStartDateToProductPriceHistories < ActiveRecord::Migration
        def change
                add_column :product_price_histories, :start_date, :datetime
        end
end
