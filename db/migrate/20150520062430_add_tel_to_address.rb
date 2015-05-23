class AddTelToAddress < ActiveRecord::Migration
        def change
                add_column :addresses, :tel, :string
        end
end
