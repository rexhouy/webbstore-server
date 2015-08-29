class ChangeProductPrice < ActiveRecord::Migration
        def change
                remove_column :products, :storage
                remove_column :products, :sales
                add_column :specifications, :price, :decimal, precision: 8, scale: 2
                add_column :specifications, :storage, :integer
                add_column :specifications, :sales, :integer
        end
end
