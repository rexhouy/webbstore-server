# -*- coding: utf-8 -*-
class Admin::ReservationsController < AdminController

        before_action :set_reservation, only: [:confirm, :cancel]

        def index
                @tel = params[:tel]
                if @tel.present?
                        @reservations = Reservation.where(contact_tel: @tel).paginate(page: params[:page])
                else
                        @status = params[:status] || "placed"
                        @reservations = Reservation.status(@status).paginate(page: params[:page])
                end
        end

        def confirm
                @reservation.update(status: Reservation.statuses[:confirmed])
                redirect_to admin_reservations_path, notice: "更新成功"
        end

        def cancel
                @reservation.update(status: Reservation.statuses[:canceled])
                redirect_to admin_reservations_path, notice: "更新成功"
        end

        private
        def set_reservation
                @reservation = Reservation.find(params[:id])
        end

end
