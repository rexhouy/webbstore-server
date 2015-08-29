class AddChannelToProducts < ActiveRecord::Migration
        def change
                rename_column :products, :channel, :channel_id
                add_foreign_key :products, :channels
                add_foreign_key :channels, :groups
        end
end
