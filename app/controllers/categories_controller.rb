class CategoriesController < ApplicationController

        def index
                @categories = Category.root.owner(Rails.application.config.owner)
        end

end
