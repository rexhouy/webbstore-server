class Admin::ImagesController < ApplicationController

        def create
                uploader = ImageUploader.new
                uploader.store!(params[:file])
                image_url = (params[:thumb].eql? "true") ? uploader.thumb.url : uploader.url
                render json: { filelink: get_url(image_url) }
        end

        private
        def get_url(local_path)
                Config::UPLOADS["base_url"] + local_path.gsub(Config::UPLOADS["storage_path"], "")
        end

end
