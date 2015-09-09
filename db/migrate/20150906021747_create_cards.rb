class CreateCards < ActiveRecord::Migration
        def change
                create_table :cards do |t|
                        t.integer :user_id
                        t.integer :specification_id
                        t.integer :order_id
                        t.integer :count
                        t.integer :remain
                        t.date :next
                        t.integer :status
                        t.string :contact_name
                        t.string :contact_tel
                        t.string :contact_address
                        t.timestamps null: false
                end
        end
end
