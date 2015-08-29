class AddStatusToSpecification < ActiveRecord::Migration
        def change
                add_column :specifications, :status, :integer
        end
end
