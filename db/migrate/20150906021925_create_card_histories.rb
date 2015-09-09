class CreateCardHistories < ActiveRecord::Migration
        def change
                create_table :card_histories do |t|
                        t.date :delivery_date
                        t.integer :card_id
                        t.integer :remain
                        t.string :memo
                        t.timestamps null: false
                end
        end
end
