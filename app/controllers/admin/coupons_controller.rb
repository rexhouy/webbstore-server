# -*- coding: utf-8 -*-
class Admin::CouponsController < AdminController

        before_action :set_coupon, only: [:show, :edit, :update, :destroy, :dispense]

        def index
                @coupons = Coupon.owner(owner).paginate(page: params[:page])
        end

        def new
                @coupon = Coupon.new
        end

        def show
        end

        def edit
                render :show, notice: "该优惠券已经发放，不能编辑" if @coupon.dispensed
        end

        def create
                @coupon = Coupon.new(coupon_params)
                @coupon.seller_id = owner
                if @coupon.save!
                        redirect_to action: "show", id: @coupon.id, notice: "创建成功"
                else
                        render :new
                end
        end

        def update
                if @coupon.update(coupon_params)
                        redirect_to admin_coupon_url(@coupon), notice: "更新成功"
                else
                        render :edit
                end
        end

        def destroy
                @coupon.destroy
                redirect_to admin_coupons_path, notice: "删除成功"
        end

        def dispense
                user_id = params[:user_id]
                success = true
                Coupon.transaction do
                        if user_id.present? # send to special user
                                success = dispense_to_user(user_id, @coupon.id)
                                render json: {"succeed": success}
                        else #send to all
                                dispense_to_all(@coupon.id)
                                redirect_to admin_coupons_path, notice: "发放成功"
                        end
                        @coupon.update(dispensed: true)
                end
        end

        def list_available
                @coupons = Coupon.owner(owner).available
                render layout: false
        end

        private
        def set_coupon
                @coupon = Coupon.find(params[:id])
                render_404 unless @coupon.seller_id.eql? owner
        end

        def coupon_params
                params.require(:coupon).permit(:title, :amount, :start_date, :end_date, :limit)
        end

        def dispense_to_user(user_id, coupon_id)
                user_coupon = UserCoupon.new
                user_coupon.user_id = user_id
                user_coupon.coupon_id = coupon_id
                user_coupon.save!
        end

        def dispense_to_all(coupon_id)
                ActiveRecord::Base.connection.execute(
                                                      %(
                                                                   insert into user_coupons(user_id, coupon_id, status, created_at, updated_at)
                                                                   select id, #{coupon_id}, #{UserCoupon.statuses[:unused]}, now(), now() from users
                ))
        end

end
