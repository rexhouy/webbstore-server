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
                        redirect_to action: "show", id: @group.id, notice: "更新成功"
                else
                        render "edit"
                end
        end

        def create
                @group = Group.new(group_params)
                if @group.save
                        redirect_to action: "show", id: @group.id, notice: "创建成功"
                else
                        render "new"
                end
        end

        def new
                @group = Group.new

        end

        def destroy
                @group.status = Group.statuses[:disabled]
                @group.save
                redirect_to action: "index", notice: "删除成功"
        end

        private
        def set_group
                @group = Group.find(params[:id])
        end
        def group_params
                params.require(:group).permit(:id, :name, :parent_id)
        end

end
