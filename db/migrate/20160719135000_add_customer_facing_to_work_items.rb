class AddCustomerFacingToWorkItems < ActiveRecord::Migration
  def change
    add_column :work_items, :customer_facing, :boolean, default: true
  end
end
