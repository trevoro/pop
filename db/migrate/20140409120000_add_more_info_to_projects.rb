class AddMoreInfoToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :more_info, :string
  end
end
