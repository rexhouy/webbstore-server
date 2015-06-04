class CreateSpecifications < ActiveRecord::Migration
        def change
                create_table :specifications do |t|
                        t.string :name
                        t.string :value
                        t.references :product
                        t.timestamps null: false
                end

                add_foreign_key :specifications, :products, on_delete: :cascade
        end
end
