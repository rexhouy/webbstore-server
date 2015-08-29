class AddGroupstoArticles < ActiveRecord::Migration
        def change
                add_foreign_key :articles, :groups
        end
end
