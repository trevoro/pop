class CreateTeamUpdates < ActiveRecord::Migration
  def change
    create_table :team_updates do |t|
      t.string :team
      t.string :title
      t.text :summary
      t.integer :week
      t.integer :year

      t.timestamps
    end
  end
end
