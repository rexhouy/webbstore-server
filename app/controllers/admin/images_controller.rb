class Admin::ImagesController < ApplicationController

        # Class variables
        def initialize
                @@config ||= YAML.load((ERB.new File.new("#{Rails.root}/config/uploads.yml").read).result)[Rails.env]
        end

        def create
                uploader = ImageUploader.new
                uploader.store!(params[:file])
                render json: { filelink: get_url(uploader.url) }
        end

        private
        def get_url(local_path)
                @@config["base_url"] + local_path.gsub(@@config["storage_path"], "")
        end

end
