class CreateWorkItems < ActiveRecord::Migration
  def change
    create_table :work_items do |t|
      t.string :key
      t.string :project
      t.text :summary
      t.string :status
      t.integer :statusCategory
      t.integer :week
      t.integer :year
      t.string :reporter
      t.string :assignee
      t.integer :num_people
      t.string :people
      t.integer :workItemType, default: 0

      t.timestamps
    end

    add_index :work_items, :key
  end
end
