# -*- coding: utf-8 -*-
module Admin::ProductsHelper

        def supplier_options(selected)
                suppliers = Supplier.owner(current_user.group_id).all || []
                options_from_collection_for_select(suppliers, :id, :name, selected)
        end

        def category_options(category_id)
                root = Category.root.owner(current_user.group.id)
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

        def product_type(product)
                return "普通商品" unless product.is_crowdfunding
                "众筹商品"
        end

        def crowdfunding_status(product)
                100 * product.sales / product.crowdfunding.threshold
        end

end
