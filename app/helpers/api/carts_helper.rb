module Api::CartsHelper

        def product_price(product)
                product["count"].to_i * product["detail"].price.to_i
        end

        def cart_price(cart)
                cart.reduce(0) do |memo, product|
                        memo += product_price(product)
                end
        end

end
