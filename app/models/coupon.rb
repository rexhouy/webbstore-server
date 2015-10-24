class Coupon < ActiveRecord::Base

        def self.owner(owner_id)
                where(seller_id: owner_id)
        end

end
