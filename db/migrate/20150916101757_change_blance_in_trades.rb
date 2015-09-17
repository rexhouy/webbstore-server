class ChangeBlanceInTrades < ActiveRecord::Migration
        def change
                rename_column :trades, :blance, :balance
        end
end
