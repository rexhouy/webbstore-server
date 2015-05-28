# -*- coding: utf-8 -*-
require "securerandom"

class Api::OrdersController < ApiController

        before_action :auth_user

        def initialize
                @@payment_config = YAML.load_file("#{Rails.root}/config/payment.yml")
        end

        def index
                @type = params[:type]
                @orders = Order.where(customer: current_user).type(@type).order(id: :desc).paginate(:page => params[:page])
                render layout: false
        end

        def show
                @order = Order.find(params[:id])
                @payment_params = payment(@order) if @order.placed? && @order.online_pay?
                render layout: false
        end

        def add
                return render json: {success: false, info: "购物失败", errors: @errors} unless validate
                begin
                        order = Order.new
                        order.customer = current_user
                        order.seller = get_seller
                        Order.transaction do
                                order.orders_products = get_orders_products
                                order.status = Order.statuses[:placed]
                                order.subtotal = subtotal(order.orders_products)
                                order.order_id = "#{SecureRandom.random_number(10**7)}-#{SecureRandom.random_number(10**7)}"
                                order.address = get_address
                                order.payment_type = params[:paymentType]
                                order.name = order_name order.orders_products
                                order.save!
                                update_product_sales(order.orders_products, :+)
                        end
                        clear_cart
                        render json: {success: true, id: order.id}
                rescue => error
                        logger.error error
                        render json: {success: false, info: "购买失败", errors: @errors}
                end

        end

        def cancel
                order = Order.find(params[:id])
                if order and order.customer.id.eql? current_user.id
                        order.status = Order.statuses[:canceled]
                        begin
                                Order.transaction do
                                        order.save!
                                        update_product_sales(order.orders_products, :-)
                                end
                        rescue => error
                                logger.error error
                                flash[error] = [@errors]
                        end
                else
                        flash[error] = ["订单不存在"]
                end
                redirect_to action: "show", id: order.id
        end

        private
        def update_product_sales(orders_products, func)
                orders_products.each do |order_product|
                        if order_product.specification.nil?
                                order_product.product.sales = order_product.product.sales.send(func, order_product.count)
                                order_product.product.save!
                        else
                                order_product.specification.sales = order_product.specification.sales.send(func, order_product.count)
                                order_product.specification.save!
                        end
                end
        end
        def order_name(orders_products)
                name = orders_products[0].product.name
                name << "等" if orders_products.size > 1
                name
        end

        def payment(order)
                params = @@payment_config["ipaynow"]["params"].clone
                params["mhtOrderNo"] = order.order_id
                params["mhtOrderName"] = order.name
                params["mhtOrderAmt"] = (order.subtotal * 100).to_f
                params["mhtOrderDetail"] = order.detail
                params["mhtOrderStartTime"] = order.created_at.strftime("%Y%m%d%H%M%S")
                params["mhtSignature"] = SignatureService.new.sign(params)
                params
        end

        def subtotal(products)
                products.reduce(0) do |sum, p|
                        sum += p.price.to_f * p.count.to_f
                end
        end

        def get_address
                Address.find(params[:addressId])
        end

        def validate
                if get_cart.empty?
                        @errors ||= []
                        @errors << "购物车里没有商品"
                        return false
                end
                true
        end

        def get_seller
                product_id = get_cart[0]["id"]
                Product.find(product_id).owner
        end

        def get_orders_products
                orders_products = []
                get_cart.each do |product|
                        op = OrdersProducts.new
                        op.count = product["count"]
                        p = Product.find(product["id"])
                        op.price = p.price
                        op.product = p
                        unless product["spec_id"].nil?
                                op.specification = Specification.find(product["spec_id"])
                                op.price = op.specification.price
                        end
                        if has_enough_storage? op
                                orders_products << op
                        else
                                @errors ||= []
                                if product["spec_id"].nil?
                                        @errors << "产品[#{p.name}]仅剩#{p.storage-p.sales}件"
                                else
                                        @errors << "产品[#{p.name}]仅剩#{op.specification.storage-op.specification.sales}件"
                                end
                        end
                end
                raise "产品剩余数量不足" unless @errors.nil?
                orders_products
        end

        def has_enough_storage?(order_product)
                storage = (order_product.specification.nil?) ?
                order_product.product.storage - order_product.product.sales :
                        order_product.specification.storage - order_product.specification.sales
                storage >= order_product.count
        end

end
