# -*- coding: utf-8 -*-
class Admin::ArticlesController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create
        before_action :set_article, only: [:show, :edit, :update, :destroy]

        def index
                @articles = Article.owner(owner).paginate(page: params[:page])
        end

        def edit
        end

        def new
                @article = Article.new
        end

        def destroy
                article.destroy
                redirect_to admin_articles_path, notice: "删除成功"
        end

        def create
                @article = Article.new(article_param)
                authorize! :create, @article
                @article.group_id = owner
                if @article.save
                        redirect_to admin_article_path(@article), notice: "创建成功"
                else
                        render :new
                end
        end

        def update
                if @article.update(article_param)
                        redirect_to admin_article_path(@article), notice: "更新成功"
                else
                        render :edit
                end
        end

        def show
        end

        private
        def set_article
                @article = Article.find(params[:id])
                render_404 unless @article.group_id.eql? owner
        end
        def article_param
                params.require(:article).permit(:title, :content)
        end
end
