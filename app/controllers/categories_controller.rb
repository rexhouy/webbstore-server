class CategoriesController < ApiController

        def index
                @categories = Category.owner(owner).root
        end

        private
        def owner
                Rails.application.config.owner
        end


end
