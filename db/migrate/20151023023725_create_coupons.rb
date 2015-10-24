class CreateCoupons < ActiveRecord::Migration
        def change
                create_table :coupons do |t|
                        t.date :start_date
                        t.date :end_date
                        t.string :title
                        t.decimal :amount, precision: 8, scale: 2
                        t.integer :limit
                        t.integer :seller_id
                        t.boolean :dispensed

                        t.timestamps null: false
                end
        end
end
