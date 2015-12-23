class AddPrinterInfoToGroups < ActiveRecord::Migration
        def change
                add_column :groups, :printer_sn, :string
                add_column :groups, :printer_key, :string
        end
end
