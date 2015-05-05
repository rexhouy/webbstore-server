class CreateOrdersProducts < ActiveRecord::Migration
        def change
                create_table :orders_products do |t|
                        t.integer :count
                        t.decimal :price
                        t.integer :order_id
                        t.integer :product_id
                        t.timestamps null: false
                end
        end
end
