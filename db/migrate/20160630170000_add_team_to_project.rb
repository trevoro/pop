class AddTeamToProject < ActiveRecord::Migration
    def change
        add_column :projects, :project_handle, :string
        add_column :projects, :team_id, :integer
        add_index  :projects, :team_id
    end
end
