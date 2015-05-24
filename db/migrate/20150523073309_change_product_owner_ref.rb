class ChangeProductOwnerRef < ActiveRecord::Migration
        def change
                remove_foreign_key "products", column: "owner_id"
                add_foreign_key "products", "groups", column: "owner_id"
        end
end
