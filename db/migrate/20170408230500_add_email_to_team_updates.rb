class AddEmailToTeamUpdates < ActiveRecord::Migration
  def change
    add_column :team_updates, :email, :string
  end
end
