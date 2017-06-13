class AddProductToWorkItems < ActiveRecord::Migration
  def change
    add_column :work_items, :product, :string
  end
end
