class ChangeOrdersUserCouponsRelation < ActiveRecord::Migration
        def change
                remove_reference :orders, :user_coupon
                add_reference :user_coupons, :order
        end
end
