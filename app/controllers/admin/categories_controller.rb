# -*- coding: utf-8 -*-
class Admin::CategoriesController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create
        before_action :set_category, only: [:show, :edit, :update, :destroy]

        def index
                @categories = Category.owner(owner).paginate(page: params[:page])
        end

        def edit
        end

        def new
                @category = Category.new
        end

        def destroy
                @category.destroy
                redirect_to admin_categories_path, notice: "删除成功"
        end

        def create
                @category = Category.new(category_param)
                authorize! :create, @category
                @category.group_id = owner
                if @category.save
                        redirect_to action: "show", id: @category.id
                else
                        render :new
                end
        end

        def update
                if @category.update(category_param)
                        redirect_to action: "show", id: @category.id
                else
                        render :edit
                end
        end

        def show
        end

        private
        def set_category
                @category = Category.find(params[:id])
                render_404 unless @category.group_id.eql? owner
        end

        def category_param
                params.require(:category).permit(:name, :category_id, :priority)
        end

end
