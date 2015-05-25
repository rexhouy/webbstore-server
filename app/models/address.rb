class Address < ActiveRecord::Base
        belongs_to :user

        enum status: [:active, :disabled]

        before_create :set_default_value

        private
        def set_default_value
                self.status = Address.statuses[:active]
        end

end
