# -*- coding: utf-8 -*-
module ReservationsHelper

        def seats_options(max)
                options = ""
                max.times do |i|
                        options << %Q(<option value="#{i+1}">#{i+1} 人</option>)
                end
                options.html_safe
        end

        def reservation_status(reservation)
                return %Q(<span class="text-success">有效</span>).html_safe if reservation.placed?
                return %Q(<span class="text-danger">过期</span>).html_safe if reservation.expired?
                return %Q(<span class="text-danger">已取消</span>).html_safe if reservation.canceled?
                return "已使用" if reservation.confirmed?
                ""
        end

end
