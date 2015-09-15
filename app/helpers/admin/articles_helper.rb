module Admin::ArticlesHelper
        def category_options
                root = Category.root
                options = ""
                root.each do |c|
                        if c.children.empty?
                                options << "<option value='#{c.id}'>#{c.name}</option>"
                        else
                                options << "<optgroup label='#{c.name}'>"
                                c.children.each do |sub|
                                        options << "<option value='#{sub.id}'>#{sub.name}</option>"
                                end
                                options << "</optgroup>"
                        end
                end
                options.html_safe
        end
end
