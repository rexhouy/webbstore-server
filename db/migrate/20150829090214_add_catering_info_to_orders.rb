class AddCateringInfoToOrders < ActiveRecord::Migration
        def change
                add_column :orders, :person_count, :integer
                add_column :orders, :catering_time, :integer
        end
end
