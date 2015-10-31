class AddFromToUserCoupons < ActiveRecord::Migration
        def change
                add_column :user_coupons, :from, :string
        end
end
