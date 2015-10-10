# -*- coding: utf-8 -*-
class Product < ActiveRecord::Base
        belongs_to :owner, class_name: "Group", foreign_key: :owner_id
        belongs_to :supplier
        belongs_to :category
        has_many :specifications, -> { where(status: Specification.statuses[:available]) }
        accepts_nested_attributes_for :specifications

        # full text index
        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks

        enum status: [:available, :disabled]

        before_create do
                self.sales = 0
                self.priority = 0
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

        def self.owner(owner_id)
                where(owner_id: owner_id)
        end

        def self.valid
                where(on_sale: true)
        end

        def self.available
                where(status: Product.statuses[:available])
        end

        def self.category(category)
                return where(category_id: category) if category.present?
                all
        end

        def self.search_by_owner(search_text, owner)
                search_params = {
                        query: {
                                match: { name: search_text }
                        },
                        from: 0,
                        size: 50,
                        filter: {
                                bool: {
                                        must: [
                                               { term: {owner_id: owner} },
                                               { term: { status: "available"} }
                                              ]
                                }
                        }
                }
                __elasticsearch__.search(search_params).records
        end

        private
        def check_specifications
                unless specifications.present? or storage.present?
                        errors.add(:base, "必须设置商品上架数量")
                end
        end

end
Product.import # for auto sync model with elastic search

class HousingProduct < Product; end
