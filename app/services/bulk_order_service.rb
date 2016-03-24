# -*- coding: utf-8 -*-
class BulkOrderService < OrderService

        def create(spec_id, order, count, payment_type, current_user)
                specification = Specification.find(spec_id)
                raise "商品不存在" if specification.nil?
                product = specification.product
                raise "商品不存在" if !product.is_bulk

                count = count.to_i * specification.batch_size

                orders_products = OrdersProducts.new
                orders_products.count = count
                orders_products.price = price(specification, current_user)
                orders_products.product_id = product.id
                orders_products.specification_id = specification.id
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
                sales = orders_products.specification.sales.send(func, orders_products.count)
                raise "库存不足，只剩#{orders_products.specification.storage - orders_products.specification.sales}件产品！" if (sales > orders_products.specification.storage)
                orders_products.specification.update(sales: sales)
                product_sales = orders_products.product.sales.send(func, orders_products.count)
                orders_products.product.update(sales: product_sales)
        end
end
