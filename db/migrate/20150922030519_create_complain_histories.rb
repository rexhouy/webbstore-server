class CreateComplainHistories < ActiveRecord::Migration
        def change
                create_table :complain_histories do |t|
                        t.datetime :time
                        t.references :complain
                        t.integer :status
                        t.string :memo
                        t.references :user
                end
        end
end
