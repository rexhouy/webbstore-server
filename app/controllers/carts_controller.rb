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
                ret = {}
                if product.nil?
                        ret[:message] = "商品不存在"
                        ret[:succeed] = false
                else
                        change_product_count(product.id, params[:spec_id], params[:count])
                        ret[:succeed] = true
                end
                render json: ret
        end

        def delete
                cart = get_cart
                cart.delete_if do |product|
                        same_product? product, params[:id], params[:spec_id]
                end
                redirect_to :carts
        end

        def confirm
                return render(:to_login) unless user_signed_in?
                @cart = get_cart_products_detail(get_cart)
                @user = current_user
                @address = Address.new
        end

        private
        def same_product?(product, id, spec_id)
                product["id"].to_s.eql?(id.to_s) && product["spec_id"].to_s.eql?(spec_id.to_s)
        end
        def get_cart_products_detail(cart)
                cart.map do |product|
                        p = product.clone
                        p["detail"] = Product.find(product["id"])
                        p["spec"] = Specification.find(product["spec_id"]) unless product["spec_id"].blank?
                        p
                end
        end
        def change_product_count(id, spec_id, count)
                cart = get_cart
                matchedProduct = cart.bsearch do |product|
                        same_product? product, id, spec_id
                end
                matchedProduct["count"] = count unless matchedProduct.nil?
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
