class DropProjectPeople < ActiveRecord::Migration
    def up
        drop_table :project_people
    end

    def down
        create_table :project_people do |t|
          t.integer  :project_id
          t.integer  :person_id
          t.datetime :start_date
          t.datetime :end_date
          t.integer  :week
          t.integer  :year

          t.timestamps
        end
    end
end
