class AddPaymentMemoToOrders < ActiveRecord::Migration

        def change
                add_column :orders, :payment_memo, :text
        end

end
