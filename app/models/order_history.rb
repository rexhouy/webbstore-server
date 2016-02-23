class OrderHistory < ActiveRecord::Base
        belongs_to :order
        belongs_to :operator, class_name: "User", foreign_key: :operator_id
        enum status: [:placed, :paid, :shipping, :delivered, :canceled, :crowdfunding_paid]
end
