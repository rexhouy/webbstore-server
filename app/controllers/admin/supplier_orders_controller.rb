class Admin::SupplierOrdersController < AdminController

        def index
                @order_products = OrdersProducts.where(supplier_id: current_user.supplier_id, status: OrdersProducts.statuses[:paid])
                        .owner(owner).paginate(:page => params[:page])
                authorize! :index, OrdersProducts
        end

end
