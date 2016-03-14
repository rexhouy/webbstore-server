class ProductPriceHistory < ActiveRecord::Base

        belongs_to :product

        before_create do
                self.sales_km = 0
                self.sales_bj = 0
        end

end
