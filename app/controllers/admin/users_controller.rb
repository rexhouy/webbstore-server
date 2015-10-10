# -*- coding: utf-8 -*-
require 'securerandom'
class Admin::UsersController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource

        def index
                @tel = params[:tel]
                if @tel.present?
                        search(@tel)
                else
                        @type = params[:type] || "manager"
                        if @type.eql? "manager"
                                @users = User.owner(owner).manager.paginate(:page => params[:page])
                        else
                                @users = User.where(role: User.roles[:customer]).paginate(page: params[:page])
                        end
                end
        end

        def edit
                @user = User.find(params[:id])
                @groups = Group.active.owner(owner).all
                @suppliers = Supplier.owner(owner).all
        end

        def unlock
                @user = User.find(params[:id])
                @user.update(failed_attempts: 0, locked_at: nil)
                redirect_to :action => "show", id: @user.id, notice: "解锁完成！该用户可以登录了。"
        end

        def update
                @user = User.find(params[:id])
                if @user.update(user_params)
                        redirect_to :action => "show", :id => @user.id
                else
                        @groups = Group.active.owner(owner).all
                        @suppliers = Supplier.owner(owner).all
                        render "edit"
                end
        end

        private
        def search(tel)
                user = User.find_by_tel(tel)
                @users = []
                @users << user if user.present? || user.customer? || user.group_id.eql?(owner)
        end
        def user_params
                params.require(:user).permit(:id, :role, :group_id, :status, :supplier_id)
        end

end
