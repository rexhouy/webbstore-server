class CreateCrowdfundings < ActiveRecord::Migration
        def change
                create_table :crowdfundings do |t|
                        t.references :product
                        t.decimal :threshold, :decimal, precision: 8, scale: 2
                        t.decimal :sells, :decimal, precision: 8, scale: 2
                        t.datetime :start_date
                        t.datetime :end_date
                        t.datetime :delivery_date
                        t.timestamps null: false
                end

                add_column :users, :location, :string
        end
end
