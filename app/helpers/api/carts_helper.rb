module Api::CartsHelper

        def product_price(product)
                unit_price = (product["spec"].nil?) ? product["detail"].price.to_i : product["spec"].price.to_i
                product["count"].to_i * unit_price
        end

        def cart_price(cart)
                cart.reduce(0) do |memo, product|
                        memo += product_price(product)
                end
        end

end
