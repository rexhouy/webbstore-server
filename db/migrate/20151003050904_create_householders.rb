class CreateHouseholders < ActiveRecord::Migration
        def change
                create_table :householders do |t|
                        t.string :no
                        t.string :name
                        t.string :tel
                        t.decimal :house_size
                        t.datetime :to_date
                        t.references :user
                        t.timestamps null: false
                end
        end
end
