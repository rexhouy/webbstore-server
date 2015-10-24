module Admin::CategoriesHelper

        def category_options(selected)
                root = Category.root.owner(current_user.group_id)
                options_from_collection_for_select(root, :id, :name, selected)
        end

end
