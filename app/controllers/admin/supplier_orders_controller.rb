class Admin::SupplierOrdersController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource

        def index
                @order_products = OrdersProducts.where(supplier_id: current_user.supplier_id, status: OrdersProducts.statuses[:paid])
                        .owner(owner).paginate(:page => params[:page])
        end

end
