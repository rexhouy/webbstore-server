class AddSupplierToProducts < ActiveRecord::Migration
        def change
                add_reference :products, :suppliers
        end
end
