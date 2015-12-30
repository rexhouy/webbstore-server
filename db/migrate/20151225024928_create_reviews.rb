class CreateReviews < ActiveRecord::Migration
        def change
                create_table :reviews do |t|
                        t.references :order
                        t.references :product
                        t.integer :score
                        t.string :memo
                        t.timestamps null: false
                end
        end
end
