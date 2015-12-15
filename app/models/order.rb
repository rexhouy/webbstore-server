# -*- coding: utf-8 -*-
class Order < ActiveRecord::Base
        belongs_to :seller, class_name: "Group", foreign_key: :seller_id
        belongs_to :customer, class_name: "User", foreign_key: :customer_id
        has_one :payment
        has_one :user_coupon
        has_many :cards
        has_many :order_histories
        has_many :orders_products, class_name: "OrdersProducts", foreign_key: :order_id, autosave: true

        enum status: [:placed, :paid, :printed, :shipping, :delivered, :canceled]
        enum payment_type: [:wechat, :alipay, :offline_pay]

        def self.owner(owner)
                return where(seller_id: owner) unless owner.eql? Rails.application.config.owner
                all
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
                        if scopes.nil?
                                scopes = where(created_at: d.beginning_of_day..d.end_of_day)
                        else
                                scopes = scopes.where(created_at: d.beginning_of_day..d.end_of_day)
                        end
                end
                scopes || all
        end

        def detail
                orders_products.reduce("") do |detail, orders_product|
                        detail << "#{orders_product.product.name},#{orders_product.count}件;"
                end
        end

end
