class AddNameToProjectSources < ActiveRecord::Migration
  def change
    add_column :project_sources, :name, :string
  end
end