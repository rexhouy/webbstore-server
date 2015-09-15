class Category < ActiveRecord::Base
        belongs_to :parent, class_name: "Category", foreign_key: :category_id
        has_many :children, dependent: :destroy, class_name: "Category"

        def self.owner(owner_id)
                where(group_id: owner_id)
        end

        def self.root
                where("category_id is null")
        end

end
