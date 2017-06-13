class AddProjectSourceIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_source_id, :integer
  end
end
