# -*- coding: utf-8 -*-
### Use favorite in products table.
### reviews table is not used.
class ReviewsController < ApiController

        before_action :authenticate_user!

        # show order review page
        def orders
                @order = Order.find(params[:id])
                return render_404 unless @order.customer_id.eql? current_user.id
                @header_ctrs = [
                                {text: "确认", onclick: "review.submit()"}
                               ]
        end

        # products review info
        def products
        end

        # update products review info
        def update
                order_id = params[:id]
                JSON.parse(params[:reviews]).each do |result|
                        review = Review.new
                        review.order_id = order_id
                        review.product_id = result["product_id"]
                        review.score = result["score"]
                        review.save!
                end
                OrderService.new.change_status(Order.find(order_id), Order.statuses[:reviewed], current_user.id)
                redirect_to "/orders/#{order_id}"
        end

        private
        def review_params
                params.require(:reviews).permit(:order_id, :product_id, :score)
        end
        def set_header
                @title = "订单评价"
                @back_url = "/orders/#{params[:id]}"
        end

end
