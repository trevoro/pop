class AddAvatarLgToPeople < ActiveRecord::Migration
  def change
    add_column :people, :avatar_lg, :string
  end
end
