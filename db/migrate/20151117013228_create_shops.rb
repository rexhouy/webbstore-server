class CreateShops < ActiveRecord::Migration
        def change
                create_table :shops do |t|
                        t.string :name
                        t.string :image
                        t.string :introduce
                        t.string :address
                        t.string :tel
                        t.references :group
                        t.integer status

                        t.timestamps null: false
                end
        end
end
