class DeleteRole < ActiveRecord::Migration
        def change
                remove_foreign_key "users", "roles"
                drop_table :roles
        end
end
