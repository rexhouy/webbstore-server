class AddMemoToOrderHistories < ActiveRecord::Migration
        def change
                add_column :order_histories, :memo, :string
        end
end
