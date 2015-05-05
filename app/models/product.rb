class Product < ActiveRecord::Base
        has_many :images, dependent: :delete_all
        accepts_nested_attributes_for :images
        belongs_to :owner, class_name: "User", foreign_key: :owner_id

        enum status: [ :off, :on_sale ]

        def self.recommend
                on_sale.where(recommend: true)
        end

end
