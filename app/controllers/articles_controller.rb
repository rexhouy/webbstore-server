# -*- coding: utf-8 -*-
class ArticlesController < ApplicationController
        def index
                @article = Article.find(params[:id])
                render layout: false
        end
end
