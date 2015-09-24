# -*- coding: utf-8 -*-
class Order < ActiveRecord::Base
        belongs_to :seller, class_name: "Group", foreign_key: :seller_id
        belongs_to :customer, class_name: "User", foreign_key: :customer_id
        has_one :payment
        has_many :order_histories
        has_many :orders_products, class_name: "OrdersProducts", foreign_key: :order_id, autosave: true

        enum status: [:placed, :paid, :shipping, :delivered, :canceled]
        enum payment_type: [:wechat, :alipay, :offline_pay]
        enum delivery_type: [:express, :self]

        def self.owner(owner)
                where(seller_id: owner)
        end

        def self.type(type)
                case type
                when "all"
                        return where.not(status: statuses[:canceled])
                when "unfinished"
                        return where("status in (?)", [statuses[:placed], statuses[:paid], statuses[:shipping]])
                when "canceled"
                        return where(status: statuses[:canceled])
                when "unpaid"
                        return where("status = ? and payment_type <> ?", statuses[:placed], payment_types[:offline_pay])
                when "wait_shipping"
                        return where("status = ? or (payment_type = ? and status = ?)", statuses[:paid], payment_types[:offline_pay], statuses[:placed])
                when "wait_delivery"
                        return where(status: statuses[:shipping])
                when "finished"
                        return where(status: statuses[:delivered])
                end
        end

        def self.search(order_id_or_tel, order_date)
                scopes = nil
                unless order_id_or_tel.blank?
                        # test if it is order_id or tel
                        if (/\d{11}/ =~ order_id_or_tel).nil?
                                scopes = where(order_id: order_id_or_tel)
                        else
                                scopes = joins(:customer).where(users: {tel: order_id_or_tel})
                        end
                end
                unless order_date.blank?
                        d = Date.parse(order_date)
                        scopes = where(created_at: d.beginning_of_day..d.end_of_day)
                end
                scopes || all
        end

        def detail
                orders_products.reduce("") do |detail, orders_product|
                        detail << "#{orders_product.product.name},#{orders_product.count}件;"
                end
        end

end
