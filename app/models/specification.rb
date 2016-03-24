# -*- coding: utf-8 -*-
class Specification < ActiveRecord::Base

        belongs_to :product

        #validations
        validates :name, presence: true
        validates :value, presence: true
        validates :storage, presence: true, numericality: { only_integer: true }

        validate :price_exist

        def price_exist
                if price.present? || (price_bj.present? && price_km.present?)
                else
                        errors.add(:price, "请输入价格信息")
                end
        end

        enum status: [:available, :disabled]

        before_create do
                self.sales = 0
                self.status = Specification.statuses[:available]
        end

end
