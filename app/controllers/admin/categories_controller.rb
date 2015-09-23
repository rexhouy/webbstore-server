class Admin::CategoriesController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create

        def index
                @categories = Category.owner(owner).paginate(:page => params[:page])
        end

        def edit
                @category = Category.find(params[:id])
                render_404 unless @category.group_id.eql?(current_user.group_id)
                @root = Category.root.owner(owner)
        end

        def new
                @category = Category.new
                @root = Category.root.owner(owner)
        end

        def destroy
                category = Category.find(params[:id])
                return render_404 unless category.group_id.eql? current_user.group_id
                category.destroy
                redirect_to admin_categories_path
        end

        def create
                @category = Category.new(category_param)
                authorize! :create, @category
                @category.group_id = owner
                if @category.save
                        redirect_to :action => "show", :id => @category.id
                else
                        render :new
                end
        end

        def update
                @category = Category.find(params[:id])
                if @category.update(category_param)
                        redirect_to :action => "show", :id => @category.id
                else
                        render :edit
                end
        end

        def show
                @category = Category.find_by_id(params[:id])
        end

        private
        def category_param
                params.require(:category).permit(:name, :category_id, :priority)
        end

end
