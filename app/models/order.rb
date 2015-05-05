class Order < ActiveRecord::Base
        belongs_to :seller, class_name: "User", foreign_key: :seller_id
        belongs_to :customer, class_name: "User", foreign_key: :customer_id
        has_many :orders_products, class_name: "OrdersProducts", foreign_key: :order_id
end
