class AddBulkInfoToSpecifications < ActiveRecord::Migration
        def change
                add_column :specifications, :batch_size, :integer
                add_column :specifications, :is_bulk, :boolean
                add_column :specifications, :price_km, :decimal, precision: 8, scale: 2
                add_column :specifications, :price_bj, :decimal, precision: 8, scale: 2
        end
end
