class CreateAddresses < ActiveRecord::Migration
        def change
                create_table :addresses do |t|
                        t.string :city
                        t.string :state
                        t.string :street
                        t.integer :user_id
                        t.timestamps null: false
                end
        end
end
