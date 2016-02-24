class MenusController < ApiController

        def index
                menu_type
                render_404 if params[:sid].nil? || !Group.availble?(params[:sid])
                session[:shop_id] = nil
                session[:dinning_table_id] = nil
                session[:shop_id] = params[:sid]
                session[:dinning_table_id] = params[:tid] if params[:tid].present? && DinningTable.availble(params[:sid], params[:tid])
                redirect_to products_url
        end

end
