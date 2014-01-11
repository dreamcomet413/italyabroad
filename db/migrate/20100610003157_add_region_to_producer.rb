class AddRegionToProducer < ActiveRecord::Migration
  def self.up
    add_column :producers, :region_id, :integer
  end

  def self.down
    remove_column :producers, :region_id
  end
end
