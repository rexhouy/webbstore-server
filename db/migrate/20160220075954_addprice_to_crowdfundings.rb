class AddpriceToCrowdfundings < ActiveRecord::Migration
        def change
                remove_column :crowdfundings, :sells
                add_column :crowdfundings, :price_km, :decimal, precision: 8, scale: 2
                add_column :crowdfundings, :price_bj, :decimal, precision: 8, scale: 2
                add_column :crowdfundings, :threshold_per_trade, :decimal, precision: 8, scale: 2
        end
end
