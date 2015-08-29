class ChangeTelDataType < ActiveRecord::Migration
        def change
                change_column :users, :tel, :integer, limit: 11
        end
end
