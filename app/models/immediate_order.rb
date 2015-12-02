class ImmediateOrder < Order

        def self.type(type)
                case type
                when "wait_shipping"
                        return where.not(status: statuses[:canceled])
                when "canceled"
                        return where(status: statuses[:canceled])
                end
        end

end
