class OrdersProducts < ActiveRecord::Base
        has_one :product
end
