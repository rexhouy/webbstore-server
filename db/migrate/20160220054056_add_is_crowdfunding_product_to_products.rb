class AddIsCrowdfundingProductToProducts < ActiveRecord::Migration
        def change
                add_column :products, :is_crowdfunding, :boolean
        end
end
