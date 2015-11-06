# -*- coding: utf-8 -*-
require 'securerandom'
class Admin::UsersController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource
        before_action :set_user, only: [:edit, :update, :coupon, :account_balance, :show, :deposit, :dispense, :cancel_notification]

        def index
                @tel = params[:tel]
                if @tel.present?
                        search(@tel)
                else
                        @type = params[:type] || "manager"
                        if @type.eql? "manager"
                                @users = User.owner(owner).manager.paginate(page: params[:page])
                        else
                                @users = User.where(role: User.roles[:customer]).paginate(page: params[:page])
                        end
                end
        end

        def edit
        end

        def show
        end

        def update
                if @user.update(user_params)
                        redirect_to action: "show", id: @user.id, notice: "更新成功"
                else
                        render "edit"
                end
        end

        def coupons
                @user_coupons = UserCoupon.where(user_id: @user.id).paginate(page: params[:page])
        end

        def account_balance
                @account_balance_histories = AccountBalanceHistory.where(user_id: @user.id).paginate(page: params[:page])
        end

        def deposit
                history = AccountBalanceHistory.new
                history.receipt = params[:amount]
                history.disbursment = 0;
                history.balance = params[:amount].to_f + @user.balance
                history.operator = current_user.tel
                history.comment = "管理员充值"
                history.user_id = @user.id
                User.transaction do
                        @user.update(balance: history.balance)
                        history.save!
                end
                redirect_to admin_user_path(@user), notice: "充值成功，账户余额#{@user.balance}元"
        end

        def dispense
                params[:coupon_ids].each do |coupon_id|
                        user_coupon = UserCoupon.new
                        user_coupon.user_id = @user.id
                        user_coupon.coupon_id = coupon_id
                        user_coupon.save!
                end
                redirect_to admin_user_path(@user), notice: "发放优惠券成功"
        end

        def cancel_notification
                @user.update(order_notification: false)
                redirect_to admin_order_notification_registry_path, notice: "取消用户#{@user.tel}的订单提醒成功！"
        end

        private
        def set_user
                @user = User.find(params[:id])
                render_404 unless @user.group_id.nil? || @user.group_id.eql?(owner)
        end
        def search(tel)
                user = User.find_by_tel(tel)
                @users = []
                @users << user if user.present? && (user.customer? || user.group_id.eql?(owner))
        end
        def user_params
                params.require(:user).permit(:id, :role, :group_id, :status)
        end

end
