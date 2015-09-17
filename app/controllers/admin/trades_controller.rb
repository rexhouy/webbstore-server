class Admin::TradesController < AdminController

        def index
                @supplier = params[:supplier]
                @date_start = params[:date_start]
                @date_end = params[:date_end]
                if params[:export]
                        response.headers["Content-disposition"] = "attachment; filename=trades.xls"
                        response.headers["Pragma"] = "no-cache"
                        response.headers["Content-Type"] = "application/vnd.ms-excel; charset=UTF-8"
                        @trades = Trade.owner(owner).filter(params).order(time: :asc)
                        render :excel, layout: false
                else
                        @trades = Trade.owner(owner).filter(params).order(time: :asc).paginate(:page => params[:page])
                        @suppliers = Supplier.owner(owner).all
                end
        end

end
