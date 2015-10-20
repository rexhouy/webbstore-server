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
                ret = {}
                if product.nil?
                        ret[:message] = "商品不存在"
                        ret[:succeed] = false
                else
                        count = add_product_to_cart(params[:id], nil)
                        ret[:succeed] = true
                        ret[:count] = count
                end
                render json: ret
        end

        def minus
                product = Product.valid.find(params[:id])
                ret = {}
                if product.nil?
                        ret[:message] = "商品不存在"
                        ret[:succeed] = false
                else
                        count = remove_product_from_cart(params[:id], nil)
                        ret[:succeed] = true
                        ret[:count] = count
                end
                render json: ret
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

        def update_count
                # Add product to cart or count++.
                product = Product.valid.find(params[:id])
                ret = {}
                if product.nil?
                        ret[:message] = "商品不存在"
                        ret[:succeed] = false
                else
                        cart = get_cart
                        existProduct = cart.find_index do |product|
                                same_product? product, params[:id], nil
                        end
                        count = params[:count].to_i
                        if existProduct.nil? && count > 0
                                cart << { "id" => params[:id], "count" => count, "spec_id" => nil }
                        elsif count.eql?(0)
                                cart.delete_if do |p|
                                        p["id"].eql? params[:id]
                                end
                        else
                                cart[existProduct]["count"] =  count
                        end
                        session[:cart] = cart
                        ret[:succeed] = true
                        ret[:count] = count
                        ret[:totalCount] = total_count(cart)
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

        private
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
                count = nil
                if existProduct.nil?
                        count = 1
                        cart << { "id" => id, "count" => 1, "spec_id" => spec_id }
                else
                        count = cart[existProduct]["count"].to_i + 1
                        cart[existProduct]["count"] =  count
                end
                session[:cart] = cart
                count
        end
        def remove_product_from_cart(id, spec_id)
                cart = get_cart
                existProduct = cart.bsearch do |product|
                        same_product? product, id, spec_id
                end
                count = 0
                unless existProduct.nil?
                        if existProduct["count"].to_i.eql? 1
                                cart.delete(existProduct)
                        else
                                existProduct["count"] =  existProduct["count"].to_i - 1
                                count = existProduct["count"]
                        end
                end
                session[:cart] = cart
                count
        end
        def total_count(cart)
                cart.reduce(0) do |count, p|
                        count += p["count"].to_i
                end
        end

end
