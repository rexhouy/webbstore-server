# -*- coding: utf-8 -*-
module ApplicationHelper

        def current_namespace
                controller.class.name.split("::").first
        end

        def role_name(user)
                return "管理员" if user.admin?
                return "卖家" if user.seller?
                return "顾客" if user.customer?
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
                date.strftime("%Y-%m-%d") if date.present?
        end

        def display_date_zh(date)
                date.strftime("%Y年%m月%d日") if date.present?
        end

        def display_datetime(date)
                date.strftime("%Y-%m-%d %H:%M:%S") if date.present?
        end

        def normalize_tel(tel)
                "#{tel[0..2]}****#{tel[8..11]}"
        end

        def paginate(url, obj)
                total_pages = ((obj.total_entries - 1) / obj.per_page + 1).to_i
                has_previous = obj.current_page > 1
                has_next = obj.current_page < total_pages
                                prefix = url.include?("?") ? "&" : "?"
                previous_link = has_previous ?
                        %(<li class="previous" ><a href="#{url}#{prefix}page=#{obj.current_page-1}"><span aria-hidden="true">&larr;</span> 前一页</a></li>) :
                        ""
                next_link = has_next ?
                       %(<li class="next"><a href="#{url}#{prefix}page=#{obj.current_page+1}">后一页 <span aria-hidden="true">&rarr;</span></a></li>) :
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

        def page_info(obj)
                total_pages = ((obj.total_entries - 1) / obj.per_page + 1).to_i
                %(
                    <div class="page-info">当前第#{obj.current_page}页，总计#{total_pages}页，总记录数#{obj.total_entries}</div>
                ).html_safe
        end

        def alert_info
                if notice.present?
                        return %(
                                   <div class="alert alert-info" role="alert">
                                      #{notice}
                                  </div>
                        ).html_safe
                end
                ""
        end

        def category
                return 1 if session[:category].nil?
                session[:category]["id"]
        end

        def cart_number
                cart = session[:cart] || []
                cart.reduce(0) do |sum, product|
                        sum += product["count"].to_i
                end
        end

        def product_price(product)
                product["count"].to_f * unit_price(product)
        end

        def unit_price(product)
                (product["spec"].nil?) ? product["detail"].price.to_f : product["spec"].price.to_f
        end

        def cart_price(cart)
                cart.reduce(0) do |memo, product|
                        memo += product_price(product)
                end
        end

        def admin_back_url(default)
                session[:index_path] || default
        end

end
