class Admin::MessagesController < AdminController

        def index
                @messages = Message.paginate(page: params[:page])
        end

end
