class ChangeTelToString < ActiveRecord::Migration
        def change
                change_column :users, :tel, :string, limit: 11
        end
end
