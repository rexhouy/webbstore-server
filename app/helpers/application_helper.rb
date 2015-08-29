# -*- coding: utf-8 -*-
module ApplicationHelper

        def current_namespace
                controller.class.name.split("::").first
        end

        def role_name(user)
                return "管理员" if user.admin?
                return "卖家" if user.seller?
                return "买家" if user.customer?
                return "机构管理员" if user.group_admin?
                ""
        end

        def phone_number(number)
                if number && number.size == 11
                        return "#{number.slice(0,3)}-#{number.slice(3, 4)}-#{number.slice(7,4)}"
                end
                number
        end

        def display_date(date)
                date.strftime("%Y-%m-%d")
        end

        def display_datetime(date)
                date.strftime("%Y-%m-%d %H:%M:%S")
        end

        def normalize_tel(tel)
                "#{tel[0..2]}****#{tel[8..11]}"
        end

        def paginate(url, obj)
                total_pages = ((obj.total_entries - 1) / obj.per_page + 1).to_i
                has_previous = obj.current_page > 1
                has_next = obj.current_page < total_pages
                previous_link = has_previous ?
                        %(<li class="previous" ><a href="#{url}/#{obj.current_page-1}"><span aria-hidden="true">&larr;</span> 前一页</a></li>) :
                        ""
                next_link = has_next ?
                       %(<li class="next"><a href="#{url}/#{obj.current_page+1}">后一页 <span aria-hidden="true">&rarr;</span></a></li>) :
                        ""
                %(
              <nav>
                <ul class="pager">
                  #{previous_link}
                  #{next_link}
                </ul>
              </nav>
                    ).html_safe
        end

        def channel
                return 1 if session[:channel].nil?
                session[:channel]["id"]
        end
end
