class ChangePaymentTypeName < ActiveRecord::Migration
        def change
                rename_column :payments, :type, :payment_type
                remove_column :orders, :payment
        end
end
