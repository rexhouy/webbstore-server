class CreateTables < ActiveRecord::Migration
        def change
                create_table :tables do |t|
                        t.integer :size, null: false
                        t.boolean :reserved, null: false
                        t.datetime :reserve_start
                        t.datetime :reserve_end
                        t.references :user

                        t.timestamps null: false
                end
        end
end
