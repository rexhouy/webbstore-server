class AddStatusToUserAndGroup < ActiveRecord::Migration
        def change
                add_column :users, :status, :integer
                add_column :groups, :status, :integer
        end
end
