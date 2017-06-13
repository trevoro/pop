class AddTeamIdToWorkItem < ActiveRecord::Migration
    def change
        add_column :work_items, :team_id, :integer
        add_index  :work_items, :team_id
    end
end
