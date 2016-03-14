# -*- coding: utf-8 -*-
class BulkOrderService < OrderService

        def create(product_id, order, count, payment_type, current_user)
                product = Product.find(product_id)
                raise "商品不存在" if product.nil? || !product.is_bulk

                count = count.to_i * product.batch_size

                orders_products = OrdersProducts.new
                orders_products.count = count
                orders_products.price = price(product, current_user)
                orders_products.product_id = product.id
                orders_products.seller_id = Rails.application.config.owner

                order.is_bulk = true
                order.customer_id = current_user.id
                order.seller_id = Rails.application.config.owner
                order.order_id = random_order_id
                order.subtotal = orders_products.price.to_f * count.to_f
                order.orders_products = [orders_products]
                order.status = Order.statuses[:placed]
                order.coupon_amount = 0
                order.user_account_balance = 0
                order.payment_type = payment_type
                order.name = product.name

                Order.transaction do
                        update_product_sales(orders_products, :+)
                        order.save!
                        create_order_history(order, current_user.id)
                end

                order

        end

        private
        def price(product, user)
                return product.price_bj if user.location.eql?("北京市")
                return product.price_km if user.location.eql?("昆明市")
        end


        def update_product_sales(orders_products, func)
                sales = orders_products.product.sales.send(func, orders_products.count)
                raise "库存不足，只剩#{orders_products.product.storage - orders_products.product.sales}件产品！" if (sales > orders_products.product.storage)
                orders_products.product.update(sales: sales)
        end
end
