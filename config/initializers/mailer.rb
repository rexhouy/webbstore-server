#SMTP
Rails.application.config.action_mailer.default_url_options = { :host => 'localhost' }
Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
        :address              => "smtp.126.com",
        :port                 => 25,
        :user_name            => 'mframe@126.com',
        :password             => '',
        :authentication       => 'plain',
        :enable_starttls_auto => true  }
