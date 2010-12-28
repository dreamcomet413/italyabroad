class AddConsignmentNumberToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders,:consignment_no,:string
  end

  def self.down
    remove_column :orders,:consignment_no
  end
end

