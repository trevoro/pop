class CreateProjectSources < ActiveRecord::Migration
  def change
    create_table :project_sources do |t|
      t.string :remote_id

      t.timestamps
    end
    add_index :project_sources, :remote_id, unique: true
  end
end
