class AddConsignmentNumberToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders,:consignment_no,:string unless column_exists?(:orders, :consignment_no)
  end

  def self.down
    remove_column :orders,:consignment_no
  end
end

