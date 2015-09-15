class AddPriorityToChannels < ActiveRecord::Migration
        def change
                add_column :channels, :priority, :integer
        end
end
