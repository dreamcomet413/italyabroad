class CreateShippingAgencies < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :shipping_agencies
      create_table :shipping_agencies do |t|
        t.string :name
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :shipping_agencies
  end
end

