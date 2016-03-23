# -*- coding: utf-8 -*-
module Admin::UsersHelper

        def user_status(user)
                return "被锁定" if user.access_locked?
                return "启用" if user.active?
                "禁用"
        end

        def coupon_status(user_coupon)
                return "已使用" if user_coupon.used?
                return "已过期" if user_coupon.coupon.end_date < Time.current
                "未使用"
        end

        def role_options(selected)
                options_for_select({"顾客" => "customer", "卖家" => "seller", "管理员" => "admin", "商户" => "shop_manager", "服务员" => "waiter"}, selected)
        end

        def group_options(selected)
                groups = Group.active.owner(current_user.group_id).all
                options_from_collection_for_select(groups, :id, :name, selected)
        end

        def status_options(selected)
                options_for_select([["启用", "active"], ["禁用", "disabled"]], selected)
        end

        def render_user(tel, type, users)
                if tel.present? # render search result
                        return render(partial: "customer") if users.empty? || users[0].customer?
                else # render by type
                        return render(partial: "customer") if type.eql? "customer"
                end
                render partial: "admin"
        end

end
