# -*- coding: utf-8 -*-
module DeviseHelper

        def admin_login?
                session[:previous_url].starts_with? "/admin"
        end

        def devise_error_messages!
                flash_alerts = []
                error_key = 'errors.messages.not_saved'

                if !flash.empty?
                        flash_alerts.push(flash[:error]) if flash[:error]
                        flash_alerts.push(flash[:alert]) if flash[:alert]
                        flash_alerts.push(flash[:notice]) if flash[:notice]
                        error_key = 'devise.failure.invalid'
                end

                return "" if resource.errors.empty? && flash_alerts.empty?

                style = (resource.errors.empty? && !flash[:error]) ? "alert-info" : "alert-danger"
                errors = resource.errors.empty? ? flash_alerts : resource.errors.full_messages

                messages = errors.map { |msg|
                        content_tag(:li, msg).gsub(/Password/, "密码").gsub(/Tel/, "手机号")
                }.join

                html = <<-HTML
    <div class="alert #{style}">
      <ul>#{messages}</ul>
    </div>
    HTML

                html.html_safe
        end

end
