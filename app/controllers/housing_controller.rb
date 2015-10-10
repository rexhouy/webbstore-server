# -*- coding: utf-8 -*-
class HousingController < ApplicationController
        before_action :authenticate_user!

        def index
                @householder = Householder.find_by_user_id(current_user.id)
                return redirect_to(action: "validate") unless @householder.present?
                @housing_unit_price = unit_price
        end

        def validate
                @householder = Householder.new
        end

        def new
                @householder = Householder.find_by_user_id(current_user.id)
        end

        def create
        end

        def check
                @householder = Householder.new(householder_params)
                existHouseholder = Householder.find_by_no(params[:no])
                exist = existHouseholder.present? && existHouseholder.name.eql?(@householder.name) && existHouseholder.tel.eql?(@householder.tel)
                if exist
                        @householder.update(user_id: current_user.id)
                        redirect_to action: "new"
                else
                        flash.now[:error] = "户主信息错误，如有疑问请联系物业。"
                        render :validate
                end
        end

        private
        def householder_params
                params.require(:householder).permit(:no, :name, :tel)
        end

        def housing_fee_params
                params.require(:housing_fee).premit(:householder_id, :duration, :payment_type)
        end

        def unit_price
                HousingUnitPrice.first.price
        end

        def housing_fee_end
                fee = HousingFee.find_by_user_id(current_user.id)
                fee.present? ? fee.to_date : DateTime.now
        end

        def housing_fee_to_date
                housing_fee_end.at_beginning_of_month.next_month
        end

end
