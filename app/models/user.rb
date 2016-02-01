# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
        # Include default devise modules. Others available are:
        # :confirmable, , :timeoutable and :omniauthable
        devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :authentication_keys => [:tel]

        has_many :addresses, -> { where(status: Address.statuses[:active]) }
        has_many :cards, -> { where.not(status: [Card.statuses[:unpaid], Card.statuses[:canceled]]).order(created_at: :desc) }
        has_many :user_coupons, -> { where(status: UserCoupon.statuses[:unused]) }
        has_many :coupons,  -> { where("end_date > now()") }, through: :user_coupons
        has_many :account_balance_histories, -> { order(created_at: :desc) }
        has_many :orders, class_name: "Order", foreign_key: :customer_id
        belongs_to :group

        before_create :set_default_value

        enum role: [:customer, :seller, :admin, :shop_manager, :supplier, :waiter]
        enum status: [:active, :disabled]

        # Devise use tel instead of email
        validates :tel, presence: true, length: { is: 11 }
        validates_uniqueness_of :tel
        validate :roles_and_groups
        def email_required?
                false
        end
        def roles_and_groups
                if !self.role.nil? && !self.customer? && self.group_id.nil?
                        errors[:base] << "必须为后台管理用户指定所属店铺"
                end
        end

        def self.manager
                where.not(role: roles[:customer])
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
                where("group_id in (select id from groups g where g.id = ? or g.parent_id = ?)", owner, owner)
        end

        private
        def set_default_value
                self.role ||= User.roles[:customer]
                p "++++++++++++++++++++++++++++++++"
                self.status = User.statuses[:active]
                self.introducer_token = SecureRandom.hex(8)
                self.balance = 0
        end

end
