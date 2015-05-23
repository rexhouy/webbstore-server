class ChangeStatusToOnSaleForProducts < ActiveRecord::Migration
        def change
                add_column :products, :on_sale, :boolean
                remove_column :products, :status
        end
end
