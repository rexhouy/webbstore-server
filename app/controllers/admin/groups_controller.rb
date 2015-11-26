# -*- coding: utf-8 -*-
class Admin::GroupsController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource
        before_action :set_group, only: [:edit, :update, :destroy]

        def index
                @groups = Group.active.paginate(page: params[:page])
        end

        def edit

        end

        def update
                if @group.update(group_params)
                        redirect_to admin_group_path(@group), notice: "更新成功"
                else
                        render "edit"
                end
        end

        def create
                @group = Group.new(group_params)
                @group.shop = Shop.new
                @group.shop.name = @group.name
                if @group.save!
                        redirect_to admin_group_path(@group), notice: "创建成功"
                else
                        render "new"
                end
        end

        def new
                @group = Group.new
        end

        def destroy
                Group.transaction do
                        @group.status = Group.statuses[:disabled]
                        if @group.shop.present?
                                @group.shop.status = Shop.statuses[:disabled]
                        end
                        @group.save
                end
                redirect_to admin_groups_path, notice: "删除成功"
        end

        private
        def set_group
                @group = Group.find(params[:id])
        end
        def group_params
                params.require(:group).permit(:id, :name)
        end

end
