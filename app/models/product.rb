class Product < ActiveRecord::Base
        belongs_to :owner, class_name: "Group", foreign_key: :owner_id

        before_create :set_default_value

        def self.recommend
                where(recommend: true, on_sale: true)
        end

        def self.valid
                where(on_sale: true)
        end

        private
        def set_default_value
                self.sales = 0
        end

end
