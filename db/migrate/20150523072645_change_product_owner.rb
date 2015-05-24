class ChangeProductOwner < ActiveRecord::Migration
        def change
                add_foreign_key "products", "groups", column: "owner_id"
        end
end
