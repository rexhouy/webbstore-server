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
                return render json: {success: false} unless validate
                order = Order.new
                order.customer = current_user
                order.seller = get_seller
                order.orders_products = get_orders_products
                order.status = Order.statuses[:placed]
                order.subtotal = subtotal(order.orders_products)
                order.order_id = "#{SecureRandom.random_number(10**7)}-#{SecureRandom.random_number(10**7)}"
                order.address = get_address
                order.payment_type = params[:paymentType]
                order.name = order_name
                if order.save
                        clear_cart
                        return render json: {success: true, id: order.id}
                else
                        return render json: {success: false}
                end
        end

        def cancel
                order = Order.find(params[:id])
                if order
                        order.status = Order.statuses[:canceled]
                        return render json: {success: true} if order.save
                end
                render json: {success: false}
        end

        private
        def order_name(orders_products)
                name = orders_products[0].product.name
                name << "等" if orders_products.size > 1
                name
        end

        def payment(order)
                params = @@payment_config["ipaynow"]["params"].clone
                params["mhtOrderNo"] = order.order_id
                params["mhtOrderName"] = order.name
                params["mhtOrderAmt"] = (order.subtotal * 100).to_i
                params["mhtOrderDetail"] = order.detail
                params["mhtOrderStartTime"] = order.created_at.strftime("%Y%m%d%H%M%S")
                params["mhtSignature"] = SignatureService.new.sign(params)
        end

        def subtotal(products)
                products.reduce(0) do |sum, p|
                        sum += p.price.to_i * p.count.to_i
                end
        end

        def get_address
                Address.find(params[:addressId])
        end

        def validate
                !get_cart.empty?
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
                        orders_products << op
                end
                orders_products
        end


end
