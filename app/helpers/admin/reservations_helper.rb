# -*- coding: utf-8 -*-
module Admin::ReservationsHelper

        def reservation_status(reservation)
                return "正常" if reservation.placed?
                return "过期" if reservation.expired?
                return "取消" if reservation.canceled?
                return "已确认" if reservation.confirmed?
                ""
        end

end
