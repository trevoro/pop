class CreateScreenshots < ActiveRecord::Migration[5.0]
  def change
    create_table :screenshots do |t|
      t.string :title
      t.string :caption

      t.timestamps
    end
  end
end
