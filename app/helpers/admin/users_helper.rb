# -*- coding: utf-8 -*-
module Admin::UsersHelper

        def user_status(user)
                return "被锁定" if user.access_locked?
                return "启用" if user.active?
                "禁用"
        end

end
