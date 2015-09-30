class AddSupplierToOrdersProducts < ActiveRecord::Migration
        def change
                add_column :orders_products, :supplier_id, :integer
                add_column :orders_products, :seller_id, :integer
                add_column :orders_products, :status, :integer
                add_index :orders_products, [:supplier_id, :status, :seller_id]
        end
end
