class DropProjectSources < ActiveRecord::Migration
  def up
    drop_table :project_sources
  end

  def down
    create_table :project_sources do |t|
      t.string :remote_id

      t.timestamps
    end
    add_index :project_sources, :remote_id, unique: true
  end
end
