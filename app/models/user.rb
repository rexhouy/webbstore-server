# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable and :omniauthable
        devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:tel]

        has_many :addresses, -> { where(status: Address.statuses[:active]) }
        belongs_to :role
        belongs_to :group

        before_create :set_default_value

        enum role: [:customer, :seller, :admin]
        enum status: [:active, :disabled]

        # Devise use tel instead of email
        validates :tel, presence: true, length: { is: 11 }
        validates_uniqueness_of :tel
        def email_required?
                false
        end

        def self.manager
                where("role in (?)", [roles[:seller], roles[:admin]])
        end

        def self.active
                where(status: statuses[:active])
        end

        def self.reset_password_by_token(attributes={})
                recoverable = find_or_initialize_with_error_by(:tel, attributes[:tel])
                unless recoverable.nil?
                        recoverable.reset_password!(attributes[:password], attributes[:password_confirmation])
                else
                        recoverable.errors.add(:tel, "不存在")
                end
                recoverable
        end

        private
        def set_default_value
                self.role ||= User.roles[:customer]
                self.status = User.statuses[:active]
        end

end
