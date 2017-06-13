class RenameWorkItemKeyColumn < ActiveRecord::Migration
  def change
      rename_column :work_items, :key, :item_key
  end
end
