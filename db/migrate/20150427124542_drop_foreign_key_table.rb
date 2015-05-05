class DropForeignKeyTable < ActiveRecord::Migration
  def change
          drop_table :foreign_keys
  end
end
