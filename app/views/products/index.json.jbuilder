json.data (@products.map do |product|
        cart_product = @cart["#{product.id}_"]
        {"product" => product, "count" => cart_product.present? ? cart_product["count"] : 0 }
end)
