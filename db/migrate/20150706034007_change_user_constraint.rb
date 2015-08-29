class ChangeUserConstraint < ActiveRecord::Migration
        def change
                remove_index :users, [:email]
                add_index :users, [:tel], :unique => true
        end
end
