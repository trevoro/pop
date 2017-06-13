class AddTeamUpdatesCountToTeams < ActiveRecord::Migration
	def up
		add_column :teams, :team_updates_count, :integer, :default => 0

		Team.reset_column_information

		Team.find_each do |t|
			Team.reset_counters t.id, :team_updates
		end
	end

	def down
		 remove_column :teams, :team_updates_count
	end
end
