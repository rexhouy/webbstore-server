class RemoveChannelFromProducts < ActiveRecord::Migration
        def change
                remove_reference :products, :channel, index: true, foreign_key: true
        end
end
