class AddPriorityToCategories < ActiveRecord::Migration
        def change
                add_column :categories, :priority, :integer
        end
end
