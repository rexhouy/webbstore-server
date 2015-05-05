class CreateOrders < ActiveRecord::Migration
        def change
                create_table :orders do |t|
                        t.string :status
                        t.decimal :subtotal
                        t.integer :seller_id
                        t.integer :customer_id
                        t.timestamps null: false
                end
        end
end
