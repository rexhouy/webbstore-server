class ChangeCateringtimeInOrders < ActiveRecord::Migration
        def change
                remove_column :orders, :catering_time
                add_column :orders, :catering_time, :datetime
        end
end
