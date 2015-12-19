class CreateSerialNos < ActiveRecord::Migration
        def change
                create_table :serial_nos do |t|
                        t.datetime :time
                end
        end
end
