module Admin::ChannelsHelper

        def category_url_options
                url_options = ""
                Category.owner(current_user.group_id).all.each do |category|
                        url_options << "<option value=\"/products?category=#{category.id}\">#{category.name}</option>"
                end
                url_options.html_safe
        end

        def article_url_options
                url_options = ""
                Article.owner(current_user.group_id).all.each do |article|
                        url_options << "<option value=\"/articles/#{article.id}\">#{article.title}</option>"
                end
                url_options.html_safe
        end

end
