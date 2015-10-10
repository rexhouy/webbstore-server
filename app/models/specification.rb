class Specification < ActiveRecord::Base

        belongs_to :product

        #validations
        validates :name, presence: true
        validates :value, presence: true
        validates :price, presence: true, numericality: {greater_than: 0}
        validates :storage, presence: true, numericality: { only_integer: true }

        enum status: [:available, :disabled]

        before_create do
                self.sales = 0
                self.status = Specification.statuses[:available]
        end

end
