class CreateTrades < ActiveRecord::Migration
        def change
                create_table :trades do |t|
                        t.datetime :time
                        t.string :type
                        t.string :payer
                        t.integer :receipt
                        t.integer :disbursement
                        t.integer :blance
                        t.string :supplier
                        t.string :order_no
                        t.string :trade_no
                        t.integer :group_id
                end
        end
end
