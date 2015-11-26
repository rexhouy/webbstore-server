class Group < ActiveRecord::Base

        belongs_to :parent, class_name: "Group"
        has_many :children, class_name: "Group", foreign_key: "parent_id"
        has_many :users
        has_one :shop, dependent: :destroy, autosave: :true

        before_create :set_default_value

        enum status: [:active, :disabled]

        def self.active
                where(status: statuses[:active])
        end

        def self.owner(owner)
                where("parent_id = :owner or id = :owner", {owner: owner})
        end

        private
        def set_default_value
                self.status = Group.statuses[:active]
                self.parent_id = 1
        end

end
