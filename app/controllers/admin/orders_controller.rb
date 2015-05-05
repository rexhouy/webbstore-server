class Admin::OrdersController < AdminController

        def index
                @orders = Order.paginate(:page => params[:page])
        end
end
