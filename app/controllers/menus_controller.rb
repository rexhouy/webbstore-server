class MenusController < ApiController

        def index
                menu_type
                return if params[:sid].nil? || !Shop.availble?(params[:sid])
                if params[:tid].nil? || !Table
                session[:shop_id] = params[:sid]
                session[:table_id] = params[:tid]
                redirect_to products_url
        end

end
