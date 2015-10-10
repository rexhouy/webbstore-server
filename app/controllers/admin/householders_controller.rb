class Admin::HouseholdersController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create

        def index
                @householders = Householder.paginate(:page => params[:page])
        end

        def edit
                @householder = Householder.find(params[:id])
        end

        def new
                @householder = Householder.new
        end

        def destroy
                householder = Householder.find(params[:id])
                householder.destroy
                redirect_to admin_householders_path
        end

        def create
                @householder = Householder.new(householder_param)
                authorize! :create, @householder
                if @householder.save
                        redirect_to :action => "show", :id => @householder.id
                else
                        render :new
                end
        end

        def update
                @householder = Householder.find(params[:id])
                if @householder.update(householder_param)
                        redirect_to :action => "show", :id => @householder.id
                else
                        render :edit
                end
        end

        def show
                @householder = Householder.find_by_id(params[:id])
        end

        private
        def householder_param
                params.require(:householder).permit(:no, :name, :tel, :house_size)
        end
end
