class AddPriceToProduct < ActiveRecord::Migration
        def change
                add_column :products, :storage, :integer
                add_column :products, :sales, :integer
        end
end
