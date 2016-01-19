class Shop < ActiveRecord::Base
        enum status: [:active, :disabled]

        before_create :set_default_value

        def self.availble?(id)
                Shop.where(id: id, status: Shop.statuses[:active]).present?
        end

        private
        def set_default_value
                self.status = Shop.statuses[:active]
        end
end
