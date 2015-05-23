class Admin::OrdersController < AdminController

        def index
                @order_id = params[:order_id] || ""
                if @order_id.empty?
                        @type = params[:type] || "wait_shipping"
                        @orders = Order.type(@type).paginate(:page => params[:page])
                else
                        @orders = Order.where(order_id: @order_id).paginate(:page => params[:page])
                end
        end

        def show
                @order = Order.find(params[:id])
        end

        def cancel
                change_status Order.statuses[:canceled]
        end

        def shipping
                change_status Order.statuses[:shipping]
        end

        def deliver
                change_status Order.statuses[:delivered]
        end

        private
        def change_status(status)
                @order = Order.find(params[:id])
                @order.status = status
                @order.save
                redirect_to [:admin, @order]
        end

end
