class AddRegionIdToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes,:region_id,:integer #unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :recipes,:region_id
  end
end

