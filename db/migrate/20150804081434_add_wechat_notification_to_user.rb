class AddWechatNotificationToUser < ActiveRecord::Migration
        def change
                add_column :users, :wechat_openid, :string
                add_column :users, :order_notification, :boolean
        end
end
