module Admin::ProductsHelper
        def category_options(category_id)
                root = Category.root
                options = ""
                root.each do |c|
                        if c.children.empty?
                                options << "<option value='#{c.id}' #{'selected' if c.id.eql? category_id}>#{c.name}</option>"
                        else
                                options << "<optgroup label='#{c.name}'>"
                                c.children.each do |sub|
                                        options << "<option value='#{sub.id}' #{'selected' if sub.id.eql? category_id}>#{sub.name}</option>"
                                end
                                options << "</optgroup>"
                        end
                end
                options.html_safe
        end
end
