class CreateStaffs < ActiveRecord::Migration
        def change
                create_table :staffs do |t|
                        t.string :name
                        t.integer :workday
                        t.string :tel, limit: 11
                        t.string :scope
                        t.string :photo
                        t.references :group

                        t.timestamps null: false
                end
        end
end
