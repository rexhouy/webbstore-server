class HomeController < ApplicationController

        def index
                @recommendProducts = Product.recommend.all
        end

end
