class AddDatesToWorkItems < ActiveRecord::Migration
  def change
    add_column :work_items, :updated, :datetime
    add_column :work_items, :created, :datetime
  end
end
