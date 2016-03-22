json.data (@products.map do |product|
                   desc = ""
                   if product.is_bulk
                           desc = product.start_date < Time.now ? "<span class='text-success'>正在销售...</span>".html_safe : "<span class='text-danger'>开始时间：#{display_datetime product.start_date}</span>".html_safe
                   else
                           desc = product.description
                   end
                   {
                           id: product.id,
                           name: product.name,
                           description: desc,
                           cover_image: product.cover_image,
                           price: price_range(product),
                           is_bulk: product.is_bulk
                   }
           end)
