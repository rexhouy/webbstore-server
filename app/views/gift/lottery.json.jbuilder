json.coupon do
        json.amount @coupon.amount
        json.limit "使用条件：订单总金额满#{@coupon.limit.to_i}元"
        json.date "有效期：#{display_date_zh @coupon.start_date} - #{display_date_zh @coupon.end_date}"
end
