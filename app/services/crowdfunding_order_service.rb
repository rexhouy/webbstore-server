# -*- coding: utf-8 -*-
class CrowdfundingOrderService < OrderService

        def create(product_id, count, contact_address, contact_name, contact_tel, payment_type, current_user)
                product = Product.find(product_id)
                raise "商品不存在" if product.nil? || !product.is_crowdfunding

                orders_products = OrdersProducts.new
                orders_products.count = count
                orders_products.price = price(product, current_user)
                orders_products.product_id = product.id
                orders_products.seller_id = Rails.application.config.owner

                order = Order.new
                order.is_crowdfunding = true
                order.customer_id = current_user.id
                order.seller_id = Rails.application.config.owner
                order.order_id = random_order_id
                order.contact_address = contact_address
                order.contact_name = contact_name
                order.contact_tel = contact_tel
                order.subtotal = orders_products.price.to_f * count.to_f
                order.orders_products = [orders_products]
                order.status = Order.statuses[:placed]
                order.coupon_amount = 0
                order.user_account_balance = 0
                order.payment_type = payment_type
                order.name = product.name

                Order.transaction do
                        order.save!
                end

                order
        end

        def price(product, user)
                return product.crowdfunding.price_bj if user.location.eql?("北京市")
                return product.crowdfunding.price_km if user.location.eql?("昆明市")
        end

end
