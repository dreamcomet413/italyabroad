class AddShippingAgencyIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :shipping_agency_id, :integer
  end

  def self.down
    remove_column :orders, :shipping_agency_id
  end
end
