class RemoveProductOwnerReference < ActiveRecord::Migration
        def change
                remove_foreign_key "products", column: "owner_id"
        end
end
