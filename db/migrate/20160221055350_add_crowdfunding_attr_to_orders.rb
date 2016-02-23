class AddCrowdfundingAttrToOrders < ActiveRecord::Migration
        def change
                add_column :crowdfundings, :prepayment, :integer
                add_column :orders, :is_crowdfunding, :boolean
        end
end
