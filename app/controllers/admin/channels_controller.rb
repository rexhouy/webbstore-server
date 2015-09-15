class Admin::ChannelsController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create

        def index
                @channels = Channel.owner(owner).order(priority: :desc).paginate(:page => params[:page])
        end

        def edit
                @channel = Channel.find(params[:id])
                render_404 unless @channel.group_id.eql?(current_user.group_id)
        end

        def new
                @channel = Channel.new
        end

        def destroy
                channel = Channel.find(params[:id])
                return render_404 unless channel.group_id.eql? current_user.group_id
                channel.destroy
                redirect_to admin_channels_path
        end

        def create
                @channel = Channel.new(channel_param)
                authorize! :create, @channel
                @channel.group_id = owner
                if @channel.save
                        redirect_to :action => "show", :id => @channel.id
                else
                        render :new
                end
        end

        def update
                @channel = Channel.find(params[:id])
                if @channel.update(channel_param)
                        redirect_to :action => "show", :id => @channel.id
                else
                        render :edit
                end
        end

        def show
                @channel = Channel.find_by_id(params[:id])
        end

        private
        def channel_param
                params.require(:channel).permit(:name, :image, :display_title, :url, :priority)
        end

end
