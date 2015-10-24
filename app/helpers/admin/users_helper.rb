# -*- coding: utf-8 -*-
module Admin::UsersHelper

        def user_status(user)
                return "启用" if user.active?
                "禁用"
        end

        def role_options(selected)
                options_for_select({"顾客" => "customer", "卖家" => "seller", "管理员" => "admin"}, selected)
        end

        def group_options(selected)
                groups = Group.active.owner(current_user.group_id).all
                options_from_collection_for_select(groups, :id, :name, selected)
        end

        def status_options(selected)
                options_for_select([["启用", "active"], ["禁用", "disabled"]], selected)
        end


end
