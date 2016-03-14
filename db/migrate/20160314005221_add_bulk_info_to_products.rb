class AddBulkInfoToProducts < ActiveRecord::Migration
        def change
                add_column :products, :batch_size, :integer
                add_column :products, :is_bulk, :boolean
                add_column :products, :price_km, :decimal, precision: 8, scale: 2
                add_column :products, :price_bj, :decimal, precision: 8, scale: 2
                remove_column :products, :barcode
                remove_column :products, :origin_price
        end
end
