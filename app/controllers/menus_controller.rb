class MenusController < ApiController

        def index
                menu_type
                render_404 if params[:sid].nil? || !Shop.availble?(params[:sid])
                session[:shop_id] = params[:sid]
                session[:table_id] = params[:tid] if params[:tid].nil? || !Table
                redirect_to products_url
        end

end
