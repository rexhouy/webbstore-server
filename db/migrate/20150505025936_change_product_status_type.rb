class ChangeProductStatusType < ActiveRecord::Migration
  def change
          change_column :products, :status, :integer
  end
end
