class AddDisplayToStaffs < ActiveRecord::Migration
        def change
                add_column :staffs, :display, :boolean
        end
end
