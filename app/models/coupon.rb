class Coupon < ActiveRecord::Base

        has_many :user_coupons

        #validations
        validates :title, presence: true
        validates :amount, presence: true, numericality: true
        validates :limit, presence: true, numericality: true
        validates :start_date, presence: true
        validates :end_date, presence: true


        def self.owner(owner_id)
                where(seller_id: owner_id)
        end

        def self.available
                where("end_date > now()")
        end

end
