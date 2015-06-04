class AddSpecificationToOrdersProducts < ActiveRecord::Migration
        def change
                remove_reference :orders_products, :specifications
                add_reference :orders_products, :specification, index: true
                add_foreign_key :orders_products, :specifications, on_delete: :cascade
        end
end
