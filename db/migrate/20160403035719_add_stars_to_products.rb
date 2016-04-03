class AddStarsToProducts < ActiveRecord::Migration
        def change
                add_column :products, :stars, :integer
                add_column :orders_products, :stars, :integer
        end
end
