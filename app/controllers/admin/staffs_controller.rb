class Admin::StaffsController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create

        def index
                @search_text = params[:search_text]
                if @search_text.present?
                        @staffs = Staff.search(@search_text).owner(owner).paginate(:page => params[:page])
                else
                        @staffs = Staff.owner(owner).paginate(:page => params[:page])
                end
        end

        def edit
                @staff = Staff.find(params[:id])
                render_404 unless @staff.group_id.eql? current_user.group_id
        end

        def new
                @staff = Staff.new
        end

        def destroy
                staff = Staff.find(params[:id])
                return render_404 unless staff.group_id.eql? current_user.group_id
                staff.destroy
                redirect_to admin_staffs_path
        end

        def create
                @staff = Staff.new(staff_param)
                authorize! :create, @staff
                @staff.group_id = owner
                if @staff.save
                        redirect_to :action => "show", :id => @staff.id
                else
                        render :new
                end
        end

        def update
                @staff = Staff.find(params[:id])
                if @staff.update(staff_param)
                        redirect_to :action => "show", :id => @staff.id
                else
                        render :edit
                end
        end

        def show
                @staff = Staff.find_by_id(params[:id])
        end

        private
        def staff_param
                params.require(:staff).permit(:name, :workday, :tel, :scope, :photo, :display)
        end

end
