class ChangeSupplierInProducts < ActiveRecord::Migration
        def change
                rename_column :products, :suppliers_id, :supplier_id
        end
end
