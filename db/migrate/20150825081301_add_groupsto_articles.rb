class AddGroupstoArticles < ActiveRecord::Migration
        def change
                add_reference :articles, :groups
        end
end
