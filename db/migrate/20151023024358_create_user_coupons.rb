class CreateUserCoupons < ActiveRecord::Migration
        def change
                create_table :user_coupons do |t|
                        t.references :user
                        t.references :coupon
                        t.integer :status
                        t.timestamps null: false
                end
        end
end
