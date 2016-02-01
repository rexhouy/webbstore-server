class ChangeOrders < ActiveRecord::Migration
        def change
                rename_column :orders, :dinning_table_no, :dinning_table_id
                create_table :dinning_tables do |t|
                        t.references :group
                        t.integer :size
                        t.integer :table_no
                        t.timestamps
                end
        end
end
