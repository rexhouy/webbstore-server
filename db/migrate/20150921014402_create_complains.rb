class CreateComplains < ActiveRecord::Migration
        def change
                create_table :complains do |t|
                        t.references :order
                        t.text :content
                        t.string :contact_name
                        t.string :contact_tel, limit: 11
                        t.string :contact_address
                        t.string :type
                        t.references :group
                        t.integer :status
                        t.references :user
                        t.references :staff

                        t.timestamps null: false
                end
        end
end
