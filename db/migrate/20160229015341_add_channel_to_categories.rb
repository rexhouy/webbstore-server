class AddChannelToCategories < ActiveRecord::Migration
        def change
                add_reference :categories, :channel
        end
end
