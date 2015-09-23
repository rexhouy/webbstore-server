class AddColorToChannel < ActiveRecord::Migration
        def change
                add_column :channels, :color, :string
        end
end
