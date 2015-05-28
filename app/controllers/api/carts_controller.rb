# -*- coding: utf-8 -*-
# Cart products are saved in session[:cart].
# Data structure is [{:id => id, :count => num}]
class Api::CartsController < ApiController

        def show
                @cart = get_cart_products_detail(get_cart)
                render layout: false
        end

        def add
                # Add product to cart or count++.
                product = Product.valid.find(params[:id])
                ret = {}
                if product.nil?
                        ret[:message] = "商品不存在"
                        ret[:succeed] = false
                else
                        add_product_to_cart(params[:id], params[:spec_id])
                        ret[:succeed] = true
                end
                render json: ret
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
                        product["id"].eql? params[:id].to_s and product["spec_id"].eql? params[:spec_id].to_s
                end
                render json: { succeed: true }
        end

        def confirm
                return render(:to_login, layout: false) unless user_signed_in?
                @cart = get_cart_products_detail(get_cart)
                @user = current_user
                @address = Address.new
                render layout: false
        end

        private
        def get_cart_products_detail(cart)
                cart.map do |product|
                        p = product.clone
                        p["detail"] = Product.find(product["id"])
                        p["spec"] = Specification.find(product["spec_id"]) unless product["spec_id"].nil?
                        p
                end
        end
        def change_product_count(id, spec_id, count)
                cart = get_cart
                matchedProduct = cart.bsearch do |product|
                        product["id"].eql? id.to_s and (product["spec_id"].nil? or product["spec_id"].eql?(spec_id.to_s))
                end
                matchedProduct["count"] = count unless matchedProduct.nil?
        end
        def add_product_to_cart(id, spec_id)
                cart = get_cart
                existProduct = cart.bsearch do |product|
                        product["id"].eql? id and (product["spec_id"].nil? or product["spec_id"].eql?(spec_id.to_s))
                end
                if existProduct.nil?
                        cart << { "id" => id, "count" => 1, "spec_id" => spec_id }
                else
                        existProduct["count"] =  existProduct["count"].to_i + 1
                end
                session[:cart] = cart
        end

end
