class AddConstraintToCaptchas < ActiveRecord::Migration
        def change
                remove_column :captchas, :primary_key
                add_index :captchas, [:tel], :unique => true
        end
end
