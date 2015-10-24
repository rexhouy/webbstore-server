# -*- coding: utf-8 -*-
require 'securerandom'
class Admin::UsersController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource
        before_action :set_user, only: [:edit, :update]

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

        def update
                if @user.update(user_params)
                        redirect_to action: "show", id: @user.id, notice: "更新成功"
                else
                        render "edit"
                end
        end

        private
        def set_user
                @user = User.find(params[:id])
                render_404 unless @user.group_id.eql? owner
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
