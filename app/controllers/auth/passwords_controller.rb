# -*- coding: utf-8 -*-
class Auth::PasswordsController < Devise::PasswordsController

        before_filter :check_captcha, only: [:create]

        # GET /resource/password/new
        # def new
        #   super
        # end

        # POST /resource/password
        def create
                update
        end

        # GET /resource/password/edit?reset_password_token=abcdef
        # def edit
        #   super
        # end

        # PUT /resource/password
        # def update
        #   super
        # end

        # protected

        # def after_resetting_password_path_for(resource)
        #   super(resource)
        # end

        # The path used after sending reset password instructions
        # def after_sending_reset_password_instructions_path_for(resource_name)
        #   super(resource_name)
        # end

        private

        def check_captcha
                tel = params[:user][:tel]
                captcha = params[:tel_captcha]
                c = Captcha.find_by_tel(tel)
                if !c.nil? && c.register_token.eql?(captcha)
                        # CAPTCHA correct
                else
                        self.resource = User.new
                        self.resource.tel = tel
                        flash[:error] = "验证码不正确."
                        render "new"
                end
        end

end
