class AddTeamIdToTeamUpdate < ActiveRecord::Migration
    def change
        add_column :team_updates, :team_id, :integer
        add_index  :team_updates, :team_id
    end
end
