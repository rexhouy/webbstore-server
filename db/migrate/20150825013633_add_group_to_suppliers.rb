class AddGroupToSuppliers < ActiveRecord::Migration
        def change
                add_foreign_key :suppliers, :groups
        end
end
