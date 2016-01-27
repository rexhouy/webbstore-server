class CreateDinningTables < ActiveRecord::Migration
        def change
                create_table :dinning_tables do |t|
                        t.references :group, null: false
                        t.integer :size, null: false
                        t.integer :table_no, null: false

                        t.timestamps null: false
                end

                add_column :orders, :dinning_table_no, :integer
        end
end
