class CreateOrderHistories < ActiveRecord::Migration
        def change
                create_table :order_histories do |t|
                        t.references :order
                        t.integer :status
                        t.datetime :time
                        t.integer :operator_id
                end
        end
end
