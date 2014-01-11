class AddRegionIdToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes,:region_id,:integer
  end

  def self.down
    remove_column :recipes,:region_id
  end
end

