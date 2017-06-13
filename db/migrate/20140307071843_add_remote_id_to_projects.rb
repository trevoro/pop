class AddRemoteIdToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :remote_id, :string
  end
end
