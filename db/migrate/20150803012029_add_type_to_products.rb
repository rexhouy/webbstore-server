class AddTypeToProducts < ActiveRecord::Migration
        def change
                add_column :products, :channel, :string
        end
end
