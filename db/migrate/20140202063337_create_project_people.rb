class CreateProjectPeople < ActiveRecord::Migration
  def change
    create_table :project_people do |t|
      t.belongs_to :project
      t.belongs_to :person
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end
  end
end
