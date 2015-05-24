class ChangeOrderSeller < ActiveRecord::Migration
        def change
                add_foreign_key "orders", "groups", column: "seller_id"
        end
end
