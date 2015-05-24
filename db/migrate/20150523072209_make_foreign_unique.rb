class MakeForeignUnique < ActiveRecord::Migration
        def change
                remove_foreign_key "addresses", "users"
                remove_foreign_key "orders", column: "customer_id"
                remove_foreign_key "orders", column: "seller_id"
                remove_foreign_key "orders_products", "orders"
                remove_foreign_key "orders_products", "products"
                remove_foreign_key "products", column: "owner_id"
        end
end
