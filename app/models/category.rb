class Category < ActiveRecord::Base
        belongs_to :category
        has_many :children, dependent: :destroy, class_name: "Category"

        def self.owner(owner_id)
                where(group_id: owner_id)
        end

end
