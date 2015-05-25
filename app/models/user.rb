class User < ActiveRecord::Base
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable and :omniauthable
        devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

        has_many :addresses, -> { where(status: Address.statuses[:active]) }
        belongs_to :role
        belongs_to :group

        before_create :set_default_value

        enum role: [:customer, :seller, :admin]
        enum status: [:active, :disabled]

        def self.manager
                where("role in (?)", [roles[:seller], roles[:admin]])
        end

        def self.active
                where(status: statuses[:active])
        end

        private
        def set_default_value
                self.role ||= User.roles[:customer]
                self.status = User.statuses[:active]
        end

end
