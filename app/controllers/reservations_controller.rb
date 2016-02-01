# -*- coding: utf-8 -*-
class ReservationsController < ApiController

        before_action :authenticate_user!
        before_action :set_reservation, only: [:show, :destroy]

        def index
                @reservations = Reservation.owner(current_user.id).order(id: :desc).paginate(page: params[:page])
                @submenu = [
                            {name: "外卖订单", class:  "", href: "/orders?type=takeout"},
                            {name: "预订订单", class: "active", href: "/reservations"},
                            {name: "店内消费订单", class: "", href: "/orders?type=immediate"}]
        end

        def new
                @reservation = Reservation.new
                @reservation.contact_tel = current_user.tel
        end

        def create
                @reservation = Reservation.new(reservation_params)
                @reservation.customer_id = current_user.id
                @reservation.time = DateTime.strptime(params[:date] + params[:time], "%Y-%m-%d%H:%M")
                if @reservation.save!
                        redirect_to @reservation
                else
                        render :new
                end
        end

        def show
                @back_url = "/reservations"
        end

        def destroy
                @reservation.update(status: Reservation.statuses[:canceled])
                redirect_to @reservation
        end

        private
        def set_reservation
                @reservation = Reservation.find(params[:id])
                render_404 unless @reservation.customer_id.eql? current_user.id
        end
        def set_header
                @title = "订桌订餐"
                @back_url = "/"
        end

        def reservation_params
                params.require(:reservation).permit(:contact_name, :contact_tel, :seats)
        end

end
