# -*- coding: utf-8 -*-
class OrderService

        # create Order, OrderProduct, OrderHistory, Card
        # update Product sales, UserCoupon,User account balance
        def create(cart, payment_type, memo, user_coupon, use_account_balance, current_user)
                @order = Order.new
                @order.customer_id = current_user.id
                @order.seller_id = Rails.application.config.owner
                @order.memo = memo
                @order.order_id = random_order_id
                @order.payment_type = payment_type
                Order.transaction do
                        @order.orders_products = get_orders_products(cart)
                        @order.subtotal = subtotal(@order.orders_products)
                        coupon_amount = set_coupon(@order, current_user.id, user_coupon)
                        set_user_account_balance(@order, current_user, coupon_amount, use_account_balance)
                        @order.name = order_name @order.orders_products
                        @order.status = need_payment?(@order) ? Order.statuses[:placed] : Order.statuses[:paid]
                        @order.save!
                        CardService.new.create(@order, current_user.id)
                        update_product_sales(@order.orders_products, :+)
                        create_order_history(@order, current_user.id)
                end
                @order
        end

        def create_anonymous(cart, shop_id, payment_type)
                @order = Order.new
                @order.seller_id = shop_id
                @order.order_id = random_order_id
                @order.payment_type = payment_type
                @order.coupon_amount = 0;
                @order.user_account_balance = 0;
                Order.transaction do
                        @order.orders_products = get_orders_products(cart)
                        @order.subtotal = subtotal(@order.orders_products)
                        @order.name = order_name @order.orders_products
                        @order.status = Order.statuses[:placed]
                        @order.save!
                        update_product_sales(@order.orders_products, :+)
                        create_order_history(@order, -1)
                end
                @order
        end

        def change_status(order, status, user_id)
                order.status = status
                Order.transaction do
                        order.save!
                        create_order_history(order, user_id)
                end
                order
        end

        def cancel(order, current_user)
                unless order.present? || order.customer_id.eql?(current_user.id)
                        raise "订单不存在"
                        return order
                end
                raise "已支付订单无法取消，如有疑问请联系客服。" if current_user.customer? && !order.placed?
                order.status = Order.statuses[:canceled]
                Order.transaction do
                        order.save!
                        update_product_sales(order.orders_products, :-)
                        create_order_history(order, current_user.id)
                        return_coupon(order)
                        return_account_balance(order, current_user)
                        destroy_card(order)
                end
                order
        end

        def cancel_automate
                Order.transaction do
                        # insert order history
                        ActiveRecord::Base.connection.execute %Q(
                              insert into order_histories(order_id, status, time)
                             (select id, 5, now() from orders where addtime(created_at, '#{Rails.application.config.order_alive_duration}:0:0') < now() and status = 0))
                        # update order status
                        Order.where("addtime(created_at, '#{Rails.application.config.order_alive_duration}:0:0') < now()").where(status: Order.statuses[:placed])
                                .update_all(status: Order.statuses[:canceled])
                end
        end

        private
        def update_product_sales(orders_products, func)
                orders_products.each do |order_product|
                        unless order_product.specification.nil?
                                sales = order_product.specification.sales.send(func, order_product.count)
                                order_product.specification.update(sales: sales)
                        end
                        sales = order_product.product.sales.send(func, order_product.count)
                        order_product.product.update(sales: sales)
                end
        end

        def create_order_history(order, user_id = nil)
                history = OrderHistory.new
                history.order_id = order.id
                history.status = order.status
                history.time = Time.now
                history.operator_id = user_id if user_id
                history.save!
        end

        def random_order_id
                "#{SecureRandom.random_number(10**7).to_s.rjust(7,"0")}-#{SecureRandom.random_number(10**7).to_s.rjust(7,"0")}"
        end

        def set_coupon(order, user_id, user_coupon_id)
                unless user_coupon_id.present?
                        order.coupon_amount = 0
                        return 0
                end
                user_coupon = UserCoupon.find_by_id(user_coupon_id)
                raise "优惠券不存在" unless user_coupon.present?
                raise "优惠券不存在" unless user_coupon.user_id.eql? user_id
                raise "优惠券已被使用" if user_coupon.used?
                raise "订单未达到优惠券使用要求" if user_coupon.coupon.limit > order.subtotal
                order.coupon_amount = user_coupon.coupon.amount
                user_coupon.status = UserCoupon.statuses[:used]
                user_coupon.order = order
                user_coupon.save!
                user_coupon.coupon.amount
        end

        def set_user_account_balance(order, current_user, coupon_amount, use_account_balance)
                unless use_account_balance
                        order.user_account_balance = 0
                        return order
                end
                total_price = order.subtotal - coupon_amount
                account_balance = current_user.balance
                if account_balance.eql? 0
                        order.user_account_balance = 0
                        return order
                end
                useable_account_balance = total_price > account_balance ? account_balance : total_price
                order.user_account_balance = useable_account_balance
                current_user.update(balance: current_user.balance - useable_account_balance)
                # history
                history = AccountBalanceHistory.new
                history.disbursment = useable_account_balance
                history.receipt = 0
                history.balance = current_user.balance
                history.user_id = current_user.id
                history.comment = "订单#{order.order_id}"
                history.save!
                order
        end


        def get_orders_products(cart)
                orders_products = []
                errors = []
                cart.values.each do |product|
                        op = OrdersProducts.new
                        op.count = product["count"].to_i
                        p = Product.find(product["id"])
                        op.price = p.price
                        op.product = p
                        if product["spec_id"].present?
                                op.specification = Specification.find(product["spec_id"])
                                op.price = op.specification.price
                        end
                        if Rails.application.config.check_storage && !has_enough_storage?(op)
                                if product["spec_id"].present?
                                        errors << "产品[#{p.name}]仅剩#{op.specification.storage-op.specification.sales}件"
                                else
                                        errors << "产品[#{p.name}]仅剩#{p.storage-p.sales}件"
                                end
                        else
                                orders_products << op
                        end
                end
                raise errors.join(";") unless errors.empty?
                orders_products
        end

        def has_enough_storage?(order_product)
                storage = (order_product.specification.nil?) ?
                order_product.product.storage - order_product.product.sales :
                        order_product.specification.storage - order_product.specification.sales
                storage >= order_product.count
        end

        def subtotal(products)
                products.reduce(0) do |sum, p|
                        sum += p.price.to_f * p.count.to_f
                end
        end

        def order_name(orders_products)
                name = orders_products[0].product.name.clone
                name << "等" if orders_products.size > 1
                name
        end

        def return_coupon(order)
                return unless order.user_coupon.present?
                order.user_coupon.update(status: UserCoupon.statuses[:unused], order_id: nil)
        end

        def return_account_balance(order, current_user)
                account_balance = order.user_account_balance
                return unless account_balance.present? && account_balance > 0
                current_user.update(balance: current_user.balance + account_balance)
                history = AccountBalanceHistory.new
                history.receipt = account_balance
                history.disbursment = 0
                history.balance = current_user.balance
                history.user_id = current_user.id
                history.comment = "取消订单#{order.order_id}"
                history.save!
        end

        def need_payment?(order)
                order.subtotal - order.coupon_amount - order.user_account_balance > 0
        end

        def destroy_card(order)
                order.cards.each do |card|
                        card.update(status: Card.statuses[:canceled])
                end
        end

end
