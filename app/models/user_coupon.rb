class UserCoupon < ActiveRecord::Base

        belongs_to :user
        belongs_to :coupon

        enum status: [:unused, :used]
        before_create do
                self.status = UserCoupon.statuses[:unused]
        end

end
