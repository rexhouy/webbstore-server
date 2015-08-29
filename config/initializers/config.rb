require 'erb'
require 'yaml'
require "digest"

module Config
        PAYMENT = YAML.load((ERB.new File.new("#{Rails.root}/config/payment.yml").read).result)
        UPLOADS = YAML.load((ERB.new File.new("#{Rails.root}/config/uploads.yml").read).result)[Rails.env]
        PAYMENT_ENCRYPTED_KEY = Digest::MD5.new.update(PAYMENT["ipaynow"]["key"].encode("utf-8")).hexdigest
        SMS = YAML.load((ERB.new File.new("#{Rails.root}/config/sms.yml").read).result)[Rails.env]
end
