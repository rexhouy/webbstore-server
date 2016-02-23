json.array! @products do |product|
        json.id product.id
        json.name product.name
        json.description product.description
        json.cover_image product.cover_image
        json.price crowdfunding_product_price(product)
        json.progress (product.sales * 100 / product.crowdfunding.threshold)
        json.crowdfunding do
                json.price_km product.crowdfunding.price_km
                json.price_bj product.crowdfunding.price_bj
        end
end
