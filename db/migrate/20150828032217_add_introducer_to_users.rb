class AddIntroducerToUsers < ActiveRecord::Migration
        def change
                add_column :users, :introducer, :integer
                add_column :users, :introducer_token, :string
        end
end
