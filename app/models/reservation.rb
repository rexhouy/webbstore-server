class Reservation < ActiveRecord::Base

        enum status: [:placed, :expired, :confirmed, :canceled]

        def self.owner(user_id)
                where(customer_id: user_id)
        end

        def self.status(status)
                where(status: Reservation.statuses[status])
        end

        before_create do
                self.status = Reservation.statuses[:placed]
        end


end
