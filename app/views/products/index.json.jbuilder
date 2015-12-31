json.data (@products.map do |product|
        cart_product = @cart["#{product.id}_"]
        specs = []
        product.specifications.each do |spec|
            cart_spec_p = @cart["#{product.id}_#{spec.id}"]
            specs << {"spec" => spec, "count" => cart_spec_p.present? ? cart_spec_p["count"] : 0}
        end
        {"product" => product, "specifications" => specs, "count" => cart_product.present? ? cart_product["count"] : 0 }
end)
