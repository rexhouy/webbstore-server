class CreateSuppliers < ActiveRecord::Migration
        def change
                create_table :suppliers do |t|

                        t.string :name, null: false
                        t.timestamps null: false
                end
        end
end
