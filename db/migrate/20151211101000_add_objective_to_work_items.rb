class AddObjectiveToWorkItems < ActiveRecord::Migration
  def change
    add_column :work_items, :objective, :string
  end
end
