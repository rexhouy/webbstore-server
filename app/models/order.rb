# -*- coding: utf-8 -*-
class Order < ActiveRecord::Base
        belongs_to :seller, class_name: "User", foreign_key: :seller_id
        belongs_to :customer, class_name: "User", foreign_key: :customer_id
        has_many :orders_products, class_name: "OrdersProducts", foreign_key: :order_id, autosave: true
        belongs_to :address

        enum status: [:placed, :paid, :shipping, :delivered, :canceled]
        enum payment_type: [:online_pay, :offline_pay]


        def self.type(type)
                case type
                when "all"
                        return where.not(status: statuses[:canceled])
                when "unfinished"
                        return where("status in (?)", [statuses[:placed], statuses[:paid], statuses[:shipping]])
                when "canceled"
                        return where(status: statuses[:canceled])
                when "unpaid"
                        return where(status: statuses[:placed]).where(payment_type: payment_types[:online_pay])
                when "wait_shipping"
                        return where("status = ? or (status = ? and payment_type = ?)", statuses[:paid], statuses[:placed], payment_types[:offline_pay])
                when "wait_delivery"
                        return where(status: statuses[:shipping])
                when "finished"
                        return where(status: statuses[:delivered])
                end
        end

        def detail
                orders_products.reduce("") do |detail, orders_product|
                        detail << "#{orders_product.product.name},#{orders_product.count}件;"
                end
        end

end
