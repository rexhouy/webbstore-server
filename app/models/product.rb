class Product < ActiveRecord::Base
        has_many :images, dependent: :delete_all
        accepts_nested_attributes_for :images
        belongs_to :owner, class_name: "User", foreign_key: :owner_id

        def self.recommend
                where(recommend: true, on_sale: true)
        end

        def self.valid
                where(on_sale: true)
        end

end
