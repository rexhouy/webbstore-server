class Complain < ActiveRecord::Base
        belongs_to :staff
        belongs_to :user
        belongs_to :order
        has_many :histories, class_name: "ComplainHistory", foreign_key: :complain_id

        enum status: [:created, :processing, :finished]

        before_create do
                self.status = Complain.statuses[:created]
        end

        def self.owner(owner)
                where(group_id: owner)
        end

end
class OrderComplain < Complain
end

class RepairComplain < Complain
end
