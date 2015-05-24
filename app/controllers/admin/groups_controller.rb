class Admin::GroupsController < AdminController
        load_and_authorize_resource

        def index
                @groups = Group.active.paginate(:page => params[:page])
        end

        def edit
                @group = Group.find(params[:id])
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
        end

        def destroy
                group = Group.find(params[:id])
                group.status = Group.statuses[:disabled]
                group.save
                redirect_to :action => "index"
        end

        private
        def group_params
                params.require(:group).permit(:id, :name)
        end

end
