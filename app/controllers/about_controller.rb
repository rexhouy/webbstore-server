# -*- coding: utf-8 -*-
class AboutController < ApiController

        def index
        end

        private
        def set_header
                @title = "关于"
                @back_url = "/"
        end

end
