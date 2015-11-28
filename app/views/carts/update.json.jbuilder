json.succeed @succeed
if @succeed
     json.subtotal number_to_currency(cart_price(@cart), locale: :'zh-CN', precision: 2)
     json.totalCount @total_count
else
     json.message @message
end
