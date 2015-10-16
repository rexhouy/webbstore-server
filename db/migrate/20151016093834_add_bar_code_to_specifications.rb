class AddBarCodeToSpecifications < ActiveRecord::Migration
        def change
                add_column :specifications, :barcode, :string
        end
end
