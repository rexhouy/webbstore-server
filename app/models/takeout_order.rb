class TakeoutOrder < Order

        def self.type(type)
                case type
                when "all"
                        return where.not(status: statuses[:canceled])
                when "unfinished"
                        return where("status in (?)", [statuses[:placed], statuses[:paid], statuses[:shipping]])
                when "canceled"
                        return where(status: statuses[:canceled])
                when "unpaid"
                        return where("status = ? and payment_type <> ?", statuses[:placed], payment_types[:offline_pay])
                when "wait_shipping"
                        return where("status = ? or (payment_type = ? and status = ?)", statuses[:paid], payment_types[:offline_pay], statuses[:placed])
                when "wait_delivery"
                        return where(status: statuses[:shipping])
                when "finished"
                        return where(status: statuses[:delivered])
                end
        end

end
