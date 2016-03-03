# -*- coding: utf-8 -*-
class ArticlesController < ApplicationController
        def index
                @article = Article.find(params[:id])
                render layout: false
        end

        def catering_cm
                render layout: false
        end

        def game
                render layout: false
        end
end
