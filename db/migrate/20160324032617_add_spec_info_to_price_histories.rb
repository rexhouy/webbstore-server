class AddSpecInfoToPriceHistories < ActiveRecord::Migration
        def change
                add_column :product_price_histories, :spec_id, :integer
                add_column :product_price_histories, :spec_name, :string
        end
end
