class Specification < ActiveRecord::Base

        belongs_to :product

        #validations
        validates :name, presence: true
        validates :value, presence: true
        validates :price, presence: true, numericality: true
        validates :storage, presence: true, numericality: { only_integer: true }

        before_create do
                self.sales = 0
        end

end
