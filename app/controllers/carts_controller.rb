# -*- coding: utf-8 -*-
# Cart products are saved in session[:cart].
# Data structure is { id_spec_id: {:id => id, :count => num, :spec_id}}
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
                        add_product_to_cart(product.id, params[:spec_id], params[:count])
                        @succeed = true
                        @cart = get_cart_products_detail(get_cart)
                        @total_count = total_count
                end
        end

        def delete
                cart = get_cart
                cart.delete("#{params[:id]}_#{params[:spec_id]}")
                redirect_to :carts
        end

        private
        def set_header
                @title = "购物车"
                category = session[:category].present? ? session[:category]["id"] : 1
                @back_url = "/products?category=#{category || 1}"
        end
        def add_product_to_cart(id, spec_id, count = 1)
                cart = get_cart
                sku = "#{id}_#{spec_id}"
                if cart[sku].present?
                        cart[sku]["count"] = count.to_i
                else
                        cart[sku] = { "id" => id, "count" => count, "spec_id" => spec_id }
                end
                session[:cart] = cart
        end
        def total_count()
                cart = get_cart
                cart.values.reduce(0) do |total, p|
                        total  += p["count"].to_i
                end
        end

end
