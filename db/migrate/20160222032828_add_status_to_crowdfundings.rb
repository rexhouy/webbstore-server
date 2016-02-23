class AddStatusToCrowdfundings < ActiveRecord::Migration
        def change
                add_column :crowdfundings, :status, :integer
        end
end
