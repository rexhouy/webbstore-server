class CreateProductPriceHistories < ActiveRecord::Migration
        def change
                create_table :product_price_histories do |t|
                        t.integer :batch_size
                        t.decimal :price_km, precision: 8, scale: 2
                        t.decimal :price_bj, precision: 8, scale: 2
                        t.references :product

                        t.timestamps
                end
        end
end
