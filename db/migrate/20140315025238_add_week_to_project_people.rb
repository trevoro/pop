class AddWeekToProjectPeople < ActiveRecord::Migration
  def change
    add_column :project_people, :week, :int
    add_column :project_people, :year, :int
  end
end
