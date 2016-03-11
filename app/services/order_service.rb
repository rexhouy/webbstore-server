# -*- coding: utf-8 -*-
class OrderService

        # create Order, OrderProduct, OrderHistory
        # update Product sales, UserCoupon,User account balance
        def create(cart, payment_type, memo, user_coupon, use_account_balance, current_user)
                @order.customer_id = current_user.id
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
                        update_product_sales(@order.orders_products, :+)
                        create_order_history(@order, current_user.id)
                end
                @order
        end

        def change_status(order, status, user_id, memo = nil)
                order.status = status
                order.shipping_memo = memo if status.eql?(Order.statuses[:shipping]) && memo.present?
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
                end
                order
        end

        def payment_succeed(order_id, payment, receive = nil, memo = nil)
                order = Order.find_by_order_id(order_id)
                if order.nil?
                        Rails.logger.error "Order not found #{order_id}"
                        return false
                end
                if order.placed?
                        Order.transaction do
                                if  receive.nil?
                                        order.update(status: Order.statuses[:paid])
                                else
                                        order.status = Order.statuses[:paid]
                                        create_order_history(order, nil)
                                        order.update(status: Order.statuses[:delivered], receive: receive, payment_memo: memo)
                                end
                                create_order_history(order, nil)
                                create_payment(order, payment)
                        end
                        send_notify_to_seller(order)
                        # send_notify_to_customer(order)
                else
                        Rails.logger.error "Update order status to paid has failed. Order status incorrect. order id [#{order.order_id}], status [#{order.status}]"
                        return false
                end
                return true
        end

        def add_dishes(order, cart, current_user)
                orders_products = get_orders_products(cart)
                order.orders_products += orders_products
                order.subtotal = subtotal(order.orders_products)
                Order.transaction do
                        order.save!
                        update_product_sales(orders_products, :+)
                        create_order_history(order, current_user.id, "加菜")
                end
        end

        private
        def update_product_sales(orders_products, func)
                # update specification sales
                orders_products.each do |order_product|
                        if order_product.specification.present?
                                sales = order_product.specification.sales.send(func, order_product.count)
                                order_product.specification.update(sales: sales)
                        end
                end
                ## update product sales
                product_sales = {}
                # group count by product
                orders_products.each do |order_product|
                        count =  product_sales[order_product.product] || order_product.product.sales
                        count = count.send(func, order_product.count)
                        product_sales[order_product.product] = count
                end
                # update sales
                product_sales.each do |product, sales|
                        product.update(sales: sales)
                end
        end

        def create_order_history(order, user_id, memo=nil)
                history = OrderHistory.new
                history.order_id = order.id
                history.status = order.status
                history.time = Time.now
                history.operator_id = user_id
                history.memo = memo
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
                        orders_products << op
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

        def create_payment(order, info)
                payment = Payment.new
                payment.payment_type = order.payment_type
                payment.order_id = order.id
                payment.trade_info = info
                payment.save!
        end

        def send_notify_to_seller(order)
                sellers = find_notify_sellers(order.seller.id)
                sellers.each do |seller|
                        NotificationService.new.send_order_notify(order, seller)
                end
        end

        def send_notify_to_customer(order)
                if order.customer.wechat_openid.present?
                        NotificationService.new.send_order_notify_to_customer(order, order.customer)
                end
        end

        def find_notify_sellers(group_id)
                User.where(order_notification: true, group_id: group_id).all
        end

end
