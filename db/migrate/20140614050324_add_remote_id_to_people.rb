class AddRemoteIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :remote_id, :string
  end
end
