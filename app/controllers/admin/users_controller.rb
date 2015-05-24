class Admin::UsersController < AdminController
        load_and_authorize_resource

        def index
                @users = User.manager.active.paginate(:page => params[:page])
        end

        def edit
                @user = User.find(params[:id])
                @groups = Group.all
        end

        def update
                if params[:user][:password].blank?
                        params[:user].delete(:password)
                        params[:user].delete(:password_confirmation)
                end
                @user = User.find(params[:id])
                if @user.update(user_params)
                        redirect_to :action => "show", :id => @user.id
                else
                        @groups = Group.all
                        render "edit"
                end
        end

        def create
                if params[:user][:password].blank?
                        params[:user].delete(:password)
                        params[:user].delete(:password_confirmation)
                end
                @user = User.new(user_params)
                if @user.save
                        redirect_to :action => "show", :id => @user.id
                else
                        @groups = Group.all
                        render "new"
                end
        end

        def new
                @user = User.new
                @user.group = @user.build_group
                @groups = Group.all
        end

        def destroy
                @user = User.find(params[:id])
                @user.status = User.statuses[:disabled]
                @user.save
                redirect_to :action => "index"
        end

        private
        def user_params
                params.require(:user).permit(:id, :email, :role, :group_id, :password, :password_confirmation)
        end

end
