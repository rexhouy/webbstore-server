# -*- coding: utf-8 -*-
class Admin::ChannelsController < AdminController
        # Checks authorization for all actions using cancan
        load_and_authorize_resource except: :create
        before_action :set_channel, only: [:show, :edit, :update, :destroy]

        def index
                @channels = Channel.owner(owner).order(priority: :desc).paginate(page: params[:page])
        end

        def edit
        end

        def new
                @channel = Channel.new
        end

        def destroy
                @channel.destroy
                redirect_to admin_channels_path, notice: "删除成功"
        end

        def create
                @channel = Channel.new(channel_param)
                authorize! :create, @channel
                @channel.group_id = owner
                if @channel.save
                        redirect_to action: "show", id: @channel.id, notice: "创建成功"
                else
                        render :new
                end
        end

        def update
                if @channel.update(channel_param)
                        redirect_to action: "show", id: @channel.id, notice: "更新成功"
                else
                        render :edit
                end
        end

        def show
        end

        private
        def set_channel
                @channel = Channel.find(params[:id])
                render_404 unless @channel.group_id.eql? owner
        end
        def channel_param
                params.require(:channel).permit(:name, :image, :display_title, :url, :priority)
        end

end
