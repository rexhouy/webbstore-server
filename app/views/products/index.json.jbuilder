json.data (@products.map do |product|
                   {
                           id: product.id,
                           name: product.name,
                           description: product.description,
                           cover_image: product.cover_image,
                           price: user_price(product)
                   }
           end)
