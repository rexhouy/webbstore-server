# -*- coding: utf-8 -*-
module Admin::CouponsHelper

        def coupon_status(coupon)
                return "已过期" if coupon.end_date < Time.current
                coupon.dispensed? ? "已发放" : "未发放"
        end

end
