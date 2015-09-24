# -*- coding: utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webstore
        class Application < Rails::Application
                # Settings in config/environments/* take precedence over those specified here.
                # Application configuration should go into files in config/initializers
                # -- all .rb files in that directory are automatically loaded.

                # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
                # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
	        config.time_zone = 'Chongqing'

                # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
                # config.i18n.load_path += Dir[Rails.root.join('webstore/config/', 'locales', '*.{rb,yml}').to_s]
                I18n.load_path += Dir[Rails.root.join('config', 'locales', 'zh-CN', '*.{rb,yml}').to_s]
                config.i18n.available_locales = [:"zh-CN", :zh]
                config.i18n.default_locale = :"zh-CN"

                # Do not swallow errors in after_commit/after_rollback callbacks.
                config.active_record.raise_in_transactional_callbacks = true

                # Define which owner this app belongs to.
                config.owner = 8
	        config.domain = "cchg.tenhs.com"
	        config.name = "大大猫—春城慧谷"

        end
end
