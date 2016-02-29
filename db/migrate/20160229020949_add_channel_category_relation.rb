class AddChannelCategoryRelation < ActiveRecord::Migration
        def change
                create_table :categories_channels do |t|
                        t.references :category
                        t.references :channel
                end

                remove_column :categories, :channel_id
        end
end
