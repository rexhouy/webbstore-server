class Group < ActiveRecord::Base

        has_many :users

        before_create :set_default_value

        enum status: [:active, :disabled]

        def self.active
                where(status: statuses[:active])
        end

        private
        def set_default_value
                self.status = Group.statuses[:active]
        end


end
