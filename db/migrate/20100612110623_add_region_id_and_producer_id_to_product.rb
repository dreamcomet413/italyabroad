class AddRegionIdAndProducerIdToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :region_id, :integer
    add_column :products, :producer_id, :integer
  end

  def self.down
    remove_column :products, :producer_id
    remove_column :products, :region_id
  end
end
