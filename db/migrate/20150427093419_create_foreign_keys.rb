class CreateForeignKeys < ActiveRecord::Migration
        def change
                create_table :foreign_keys do |t|
                        add_foreign_key :addresses, :users
                        add_foreign_key :orders, :users, column: :seller_id
                        add_foreign_key :orders, :users, column: :customer_id
                        add_foreign_key :products, :users, column: :owner_id
                        add_foreign_key :orders_products, :orders
                        add_foreign_key :orders_products, :products
                        add_foreign_key :images, :products
                end
        end
end
