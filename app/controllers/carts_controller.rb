# -*- coding: utf-8 -*-
# Cart products are saved in session[:cart].
# Data structure is [{:id => id, :count => num}]
class CartsController < ApiController

        def show
                @cart = get_cart_products_detail(get_cart)
        end

        def add
                # Add product to cart or count++.
                product = Product.valid.find(params[:id])
                if product.nil?
                        @message = "商品不存在"
                        render "/error"
                else
                        add_product_to_cart(params[:id].to_s, params[:spec_id] || "")
                        redirect_to :carts
                end
        end

        def update
                product = Product.valid.find(params[:id])
                if product.nil?
                        @message = "商品不存在"
                        @succeed = false
                else
                        change_product_count(product.id, params[:spec_id], params[:count])
                        @succeed = true
                        @cart = get_cart_products_detail(get_cart)
                end
        end

        def delete
                cart = get_cart
                cart.delete_if do |product|
                        same_product? product, params[:id], params[:spec_id]
                end
                redirect_to :carts
        end

        private
        def set_header
                @title = "购物车"
                category = session[:category].present? ? session[:category]["id"] : 1
                @back_url = "/products?category=#{category || 1}"
        end
        def same_product?(product, id, spec_id)
                product["id"].to_s.eql?(id.to_s) && product["spec_id"].to_s.eql?(spec_id.to_s)
        end
        def change_product_count(id, spec_id, count)
                cart = get_cart
                matched_product_index = cart.find_index do |product|
                        same_product? product, id, spec_id
                end
                cart[matched_product_index]["count"] = count unless matched_product_index.nil?
        end
        def add_product_to_cart(id, spec_id)
                cart = get_cart
                existProduct = cart.find_index do |product|
                        same_product? product, id, spec_id
                end
                if existProduct.nil?
                        cart << { "id" => id, "count" => 1, "spec_id" => spec_id }
                else
                        cart[existProduct]["count"] =  cart[existProduct]["count"].to_i + 1
                end
                session[:cart] = cart
        end

end
