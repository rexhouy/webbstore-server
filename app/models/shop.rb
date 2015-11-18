class Shop < ActiveRecord::Base
        enum status: [:active, :disabled]

        before_create :set_default_value

        private
        def set_default_value
                self.status = Shop.statuses[:active]
        end
end
