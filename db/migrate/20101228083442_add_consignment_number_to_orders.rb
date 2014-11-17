class AddConsignmentNumberToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders,:consignment_no,:string unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :orders,:consignment_no
  end
end

