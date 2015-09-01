class AddAddressToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :contact_name, :string
                add_column :orders, :contact_tel, :string, limit: 11
                add_column :orders, :contact_address, :string
                remove_foreign_key :orders, :addresses
                remove_column :orders, :address_id
        end
end
