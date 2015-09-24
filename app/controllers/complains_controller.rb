# -*- coding: utf-8 -*-
class ComplainsController < ApplicationController

        before_action :authenticate_user!, except: [:index]

        def index
                @staffs = Staff.all
        end

        def new
                @complain = Complain.new
        end

        def new_order_complain
                @order = Order.find(params[:order_id])
                @complain = Complain.new
                @complain.order_id = @order.id
                @complain.contact_name = @order.contact_name
                @complain.contact_tel = @order.contact_tel
                @complain.contact_address = @order.contact_address
        end

        def show
                @complain = Complain.find(params[:id])
                render :show_order_complain if @complain.type.eql? "OrderComplain"
        end

        def create
                @complain = Complain.new(complain_params)
                @complain.user_id = current_user.id
                @complain.group_id = Rails.application.config.owner
                @complain.type = @complain.order_id.present? ? "OrderComplain" : "RepairComplain"
                if @complain.save!
                        create_complain_history
                        redirect_to :action => "show", :id => @complain.id
                else
                        render :new
                end
        end

        def history
                @complains = Complain.where(user_id: current_user.id).order(created_at: :desc)
        end

        private
        def complain_params
                params.require(:complain).permit(:order_id, :content, :contact_name, :contact_tel, :contact_address)
        end

        def create_complain_history
                history = ComplainHistory.new
                history.complain_id = @complain.id
                history.status = Complain.statuses[:created]
                history.time = DateTime.now
                history.user_id = current_user.id
                history.memo = "创建"
                history.save!
        end

end
