class ChangeNullabilityOfUser < ActiveRecord::Migration
        def change
                change_column :users, :email, :string, :null => true
                change_column :users, :tel, :string, :null => false, :limit => 11
        end
end
