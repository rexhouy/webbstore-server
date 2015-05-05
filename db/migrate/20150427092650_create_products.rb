class CreateProducts < ActiveRecord::Migration
        def change
                create_table :products do |t|
                        t.string :name
                        t.string :description
                        t.text :article
                        t.integer :count
                        t.decimal :price
                        t.string :status
                        t.string :cover_image
                        t.integer :owner_id
                        t.timestamps null: false
                end
        end
end
