class AddFromToCards < ActiveRecord::Migration
        def change
                add_column :cards, :from, :integer
        end
end
