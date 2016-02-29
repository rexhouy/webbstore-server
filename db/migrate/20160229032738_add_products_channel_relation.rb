class AddProductsChannelRelation < ActiveRecord::Migration
        def change
                create_table :channels_products do |t|
                        t.references :product
                        t.references :channel
                end
        end
end
