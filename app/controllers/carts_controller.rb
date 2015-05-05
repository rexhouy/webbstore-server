# -*- coding: utf-8 -*-
# Cart products are saved in session[:cart].
# Data structure is [{:id => id, :count => num}]
class CartsController < ApplicationController

        def show
                @cart = get_cart_products_detail(get_cart)
        end

        def add
                # Add product to cart or count++.
                @product = Product.valid.find(params[:id])
                if @product.nil?
                        flash[:error] = "商品不存在"
                        @cart = get_cart
                else
                        @cart = add_product_to_cart params[:id]
                end

                # Get cart products detail
                @cart = get_cart_products_detail(@cart)
                render "show"
        end

        private
        def get_cart_products_detail(cart)
                cart.map do |product|
                        p = product.clone
                        p["product"] = Product.find(product["id"])
                        p
                end
        end
        def add_product_to_cart(id)
                cart = get_cart
                exists = false
                cart.each do |product|
                        if product[:id].eql? id
                                product[:count]+=1
                                exists = true
                                break
                        end
                end
                cart << { "id" => id, "count" => 1 } unless exists
                session[:cart] = cart
        end

        def get_cart
                session[:cart] || []
        end

end
