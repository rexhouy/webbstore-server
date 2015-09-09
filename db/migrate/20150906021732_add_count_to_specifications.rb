class AddCountToSpecifications < ActiveRecord::Migration
        def change
                add_column :specifications, :count, :integer
        end
end
