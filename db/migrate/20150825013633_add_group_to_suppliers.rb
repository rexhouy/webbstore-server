class AddGroupToSuppliers < ActiveRecord::Migration
        def change
                add_reference :suppliers, :groups
        end
end
