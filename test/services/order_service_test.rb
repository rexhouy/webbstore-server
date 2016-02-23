# -*- coding: utf-8 -*-
require 'test_helper'

class OrderServiceTest < ActiveSupport::TestCase

        test "it create order" do
                cart = {
                        "1_": {"id" => 1, "spec_id" => "", "count" => 1},
                        "2_1": {"id" => 2, "spec_id" => 1, "count" => 1}
                }
                order = OrderService.new.create(cart, "alipay", "test", 1, true, User.find(1))

                # should create order
                assert order.id.present?

                #should create orders_products
                assert order.orders_products.size.eql? 2

                #should create order history
                order_history = OrderHistory.find_by_order_id(order.id)
                assert order_history.present?

                #should update product sales
                product_1 = order.orders_products[0].product
                assert_equal 1, product_1.sales, "product 1 sales update failed"
                product_2 = order.orders_products[1].product
                assert_equal 1, product_2.sales, "product 2 sales update failed"

                #should use coupon and account balance
                assert_equal 3, order.subtotal
                assert_equal 1, order.user_coupon.id
                assert_equal 1, order.coupon_amount
                assert_equal 2, order.user_account_balance.to_i

                #should update user_coupon status
                assert order.user_coupon.used?

                #should update user account balance
                user = User.find(1)
                assert_equal 98, user.balance

                #should create user account balance history
                history = AccountBalanceHistory.find_by_user_id(1)
                assert history.present?
        end

        test "it create cards" do
                cart = {
                        "2_2": {"id" => 2, "spec_id" => 2, "count" => 1}
                       }
                order = OrderService.new.create(cart, "alipay", "test", nil, false, User.find(1))

                card = Card.find_by_user_id(1)
                assert card.present?

                assert_equal 5, card.count
                assert_equal 1, card.user_id
                assert_equal 2, card.specification_id
                assert_equal order.id, card.order_id
                assert_equal "rex", card.contact_name
                assert_equal "12345678901", card.contact_tel
                assert_equal "云南昆明unknown", card.contact_address
                assert_equal "测试2", card.name
                assert_equal "open", card.status
        end

        test "it raise exceptions when there are no storage left" do
                cart = {
                        "1_": {"id" => 1, "spec_id" => "", "count" => 100}
                       }
                assert_raise do
                        OrderService.new.create(cart, "alipay", "test", nil, false, User.find(1))
                end
        end

        test "it returns coupon and user account balance when canceled" do
                cart = {
                        "1_": {"id" => 1, "spec_id" => "", "count" => 3}
                       }
                order = OrderService.new.create(cart, "alipay", "test", 1, true, User.find(1))
                assert_equal 98, User.find(1).balance
                assert UserCoupon.find(1).used?

                order = OrderService.new.cancel(order, User.find(1))
                #should return user account balance
                assert_equal 100, User.find(1).balance

                #should return coupon
                assert UserCoupon.find(1).unused?
        end

        test "it update order status and record history" do
                cart = {
                        "1_": {"id" => 1, "spec_id" => "", "count" => 3}
                       }
                order = OrderService.new.create(cart, "alipay", "test", 1, true, User.find(1))
                order = OrderService.new.change_status(order, Order.statuses[:shipping], 1)

                #should update order status
                assert order.shipping?
                #should record history
                order.order_histories
                assert_equal 2, order.order_histories.size
        end

        test "it update order status after order_alive_duration" do
                OrderService.new.cancel_automate
                order = Order.find(2)

                #should be canceled
                assert order.canceled?

                history = OrderHistory.find_by_order_id(2)
                #should record history
                assert history.present?
        end

end
