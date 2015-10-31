class GiftController < ApplicationController

        before_action :authenticate_user!, only: [:lottery]

        def index
                render layout: false
        end

        def lottery
                user_coupons = UserCoupon.where(user_id: current_user.id, from: "gift")
                if user_coupons.empty?
                        @coupon = random_coupon
                        dispense(@coupon)
                end
                respond_to do |format|
                        format.html
                        return render json: {played: true} if @coupon.nil?
                        format.json
                end
        end

        private
        def random_coupon
                case SecureRandom.random_number(100)
                when 0..34
                        return Coupon.find(1)
                when 35..59
                        return Coupon.find(2)
                when 60..79
                        return Coupon.find(3)
                when 80..94
                        return Coupon.find(4)
                else
                        return Coupon.find(5)
                end
        end

        def dispense(coupon)
                user_coupon = UserCoupon.new
                user_coupon.user_id = current_user.id
                user_coupon.coupon_id = coupon.id
                user_coupon.from = "gift"
                user_coupon.save!
                coupon.update(dispensed: true) unless coupon.dispensed
        end

end
