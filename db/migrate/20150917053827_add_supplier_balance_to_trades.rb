class AddSupplierBalanceToTrades < ActiveRecord::Migration
        def change
                add_column :trades, :supplier_balance, :decimal, precision: 8, scale: 2
        end
end
