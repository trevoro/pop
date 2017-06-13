class AddFixVersionToWorkItems < ActiveRecord::Migration
  def change
    add_column :work_items, :fix_version, :string
  end
end
