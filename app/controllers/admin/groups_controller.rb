class Admin::GroupsController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource

        def index
                @groups = Group.active.paginate(:page => params[:page])
        end

        def edit
                @group = Group.find(params[:id])
                @groups = Group.active.where("parent_id is null").all
        end

        def update
                @group = Group.find(params[:id])
                if @group.update(group_params)
                        redirect_to :action => "show", :id => @group.id
                else
                        render "edit"
                end
        end

        def create
                @group = Group.new(group_params)
                if @group.save
                        redirect_to :action => "show", :id => @group.id
                else
                        render "new"
                end
        end

        def new
                @group = Group.new
                @groups = Group.active.where("parent_id is null").all
        end

        def destroy
                group = Group.find(params[:id])
                group.status = Group.statuses[:disabled]
                group.save
                redirect_to :action => "index"
        end

        private
        def group_params
                params.require(:group).permit(:id, :name, :parent_id)
        end

end
