class ChangeProductsColumns < ActiveRecord::Migration
        def change
                add_column :products, :storage, :integer
                add_column :products, :sales, :integer
                remove_column :products, :count, :integer
        end
end
