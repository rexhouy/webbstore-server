# -*- coding: utf-8 -*-
class Product < ActiveRecord::Base
        belongs_to :owner, class_name: "Group", foreign_key: :owner_id
        has_many :specifications, dependent: :delete_all
        accepts_nested_attributes_for :specifications

        enum status: [:available, :disabled]

        before_create do
                self.sales = 0
                self.status = Product.statuses[:available]
        end

        #validations
        validates :name, presence: true
        validates :description, presence: true
        validates :price, presence: true, numericality: true
        validates :article, presence: true
        validate :check_specifications

        def self.recommend
                where(recommend: true, on_sale: true)
        end

        def self.valid
                where(on_sale: true)
        end

        def self.available
                where(status: Product.statuses[:available])
        end

        private
        def check_specifications
                unless specifications.present? or storage.present?
                        errors.add(:base, "必须设置商品上架数量")
                end
        end

end
