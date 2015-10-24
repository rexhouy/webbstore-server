class UserCoupon < ActiveRecord::Base

        enum status: [:unused, :used]
        before_create do
                self.status = UserCoupon.statuses[:used]
        end

end
