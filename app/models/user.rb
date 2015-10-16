# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
        # Include default devise modules. Others available are:
        # :confirmable, , :timeoutable and :omniauthable
        devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :authentication_keys => [:tel]

        has_many :addresses, -> { where(status: Address.statuses[:active]) }
        has_many :cards, -> { where.not(status: Card.statuses[:unpaid]).order(created_at: :desc) }
        belongs_to :group

        before_create :set_default_value

        enum role: [:customer, :seller, :admin, :group_admin, :supplier]
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

        ## validate user when sign in
        def active_for_authentication?
                super && active?
        end

        def self.owner(owner)
                where(group_id: owner)
        end

        private
        def set_default_value
                self.role ||= User.roles[:customer]
                self.status = User.statuses[:active]
                self.introducer_token = SecureRandom.hex(8)
        end

end
