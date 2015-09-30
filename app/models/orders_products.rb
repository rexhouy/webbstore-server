class OrdersProducts < ActiveRecord::Base
        belongs_to :product
        belongs_to :specification
        enum status: [:placed, :paid, :shipping, :delivered, :canceled]

        def self.owner(owner)
                where(seller_id: owner)
        end

end
