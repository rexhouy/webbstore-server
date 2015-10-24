class AddCouponAccountBalanceInfo < ActiveRecord::Migration
        def change
                add_reference :orders, :coupon
                add_column :orders, :coupon_amount, :decimal, precision: 8, scale: 2
                add_column :users, :balance, :decimal, precision: 8, scale: 2
                add_column :orders, :user_account_balance, :decimal, precision: 8, scale: 2
        end
end
