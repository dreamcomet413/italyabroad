class AddShippingAgencyIdToOrders < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :orders, :shipping_agency_id, :integer unless column_exists?(:orders, :shipping_agency_id)
    #end
  end

  def self.down
    remove_column :orders, :shipping_agency_id
  end
end
