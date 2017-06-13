class DropTeamMembers < ActiveRecord::Migration
    def up
        drop_table :team_members
    end

    def down
        create_table :team_members do |t|
            t.integer :team_id
            t.integer :person_id

            t.timestamps
        end
    end
end
