class AddAddressToOrder < ActiveRecord::Migration
        def change
                add_column :orders, :address_id, :integer
                add_foreign_key :orders, :addresses
        end
end
