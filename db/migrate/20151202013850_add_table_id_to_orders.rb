 class AddTableIdToOrders < ActiveRecord::Migration
         def change
                 add_column :orders, :dinning_table_id, :integer
         end
 end
