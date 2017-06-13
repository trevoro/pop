class RemoveProjectSourceFromProject < ActiveRecord::Migration
    def change
      remove_column :projects, :project_source_id
    end
end
