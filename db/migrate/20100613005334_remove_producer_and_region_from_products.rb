class RemoveProducerAndRegionFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :producer_name
    remove_column :products, :producer_desc
  end

  def self.down
    add_column :products, :producer_desc, :text
    add_column :products, :producer_name, :string
  end
end
