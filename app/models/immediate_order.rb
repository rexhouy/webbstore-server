class ImmediateOrder < Order

        def self.type(type)
                case type
                when "wait_shipping"
                        return where.not(status: statuses[:canceled])
                when "canceled"
                        return where(status: statuses[:canceled])
                end
        end

        def self.unpaid(owner)
                self.search(nil, Time.current.strftime("%Y-%m-%d")).where(status: Order.statuses[:placed]).owner(owner).count()
        end

end
