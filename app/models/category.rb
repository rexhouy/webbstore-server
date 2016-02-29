class Category < ActiveRecord::Base
        belongs_to :parent, class_name: "Category", foreign_key: :category_id
        has_and_belongs_to_many :channels
        has_many :children, dependent: :destroy, class_name: "Category"

        def self.owner(owner_id)
                where(group_id: owner_id)
        end

        def self.root
                where("category_id is null")
        end

end
