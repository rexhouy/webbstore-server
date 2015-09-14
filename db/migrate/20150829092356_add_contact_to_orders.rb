class AddContactToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :contact_name, :string
                add_column :orders, :contact_tel, :string, limit: 11
                add_column :orders, :contact_address, :string
                add_column :orders, :contact_sex, :integer
                remove_foreign_key :orders, :addresses
        end
end
