class MessagesController < ApiController

        def create
                @message = Message.new
                @message.content = params[:content]
                @message.save!
        end

end
