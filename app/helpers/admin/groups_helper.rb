module Admin::GroupsHelper

        def group_options(selected)
                groups = Group.active.where("parent_id is null").all
                options_from_collection_for_select(groups, :id, :name, selected)
        end

end
