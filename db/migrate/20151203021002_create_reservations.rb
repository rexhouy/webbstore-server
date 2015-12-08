class CreateReservations < ActiveRecord::Migration
        def change
                create_table :reservations do |t|
                        t.integer :seats
                        t.datetime :time
                        t.string :contact_name
                        t.string :contact_tel
                        t.string :status
                        t.integer :customer_id

                        t.timestamps null: false
                end
        end
end
