class AddFullTextSearch < ActiveRecord::Migration

        def up
                execute <<-SQL
                    alter table products
                    add fulltext index fulltext_index(name, description, article)
                SQL
        end

        def down
                execute <<-SQL
                    alter table products
                    drop index fulltext_index
                SQL
        end

end
