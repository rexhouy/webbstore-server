class Coupon < ActiveRecord::Base

        has_many :user_coupons

        def self.owner(owner_id)
                where(seller_id: owner_id)
        end

        def self.available
                where("end_date > now()")
        end

end
