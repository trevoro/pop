class AddParentTeamIdToTeam < ActiveRecord::Migration
    def change
        add_column :teams, :parent_team_id, :integer
        add_index  :teams, :parent_team_id, unique: false
    end
end
