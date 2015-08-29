class AddTelToUser < ActiveRecord::Migration
        def change
                add_column :users, :tel, :integer, limit: 11
        end
end
