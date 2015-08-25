module Api::CartsHelper

        def product_price(product)
                unit_price = (product["spec"].nil?) ? product["detail"].price.to_f : product["spec"].price.to_f
                product["count"].to_f * unit_price
        end

        def cart_price(cart)
                cart.reduce(0) do |memo, product|
                        memo += product_price(product)
                end
        end

        def choose_channel
                session[:channel] || "custom"
        end

end
