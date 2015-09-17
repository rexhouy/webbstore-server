class ChangeTradeType < ActiveRecord::Migration
        def change
                change_column :trades, :receipt, :decimal, precision: 8, scale: 2
                change_column :trades, :disbursement, :decimal, precision: 8, scale: 2
                change_column :trades, :balance, :decimal, precision: 8, scale: 2
        end
end
