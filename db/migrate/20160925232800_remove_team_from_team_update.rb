class RemoveTeamFromTeamUpdate < ActiveRecord::Migration
    def change
        remove_column :team_updates, :team
    end
end
