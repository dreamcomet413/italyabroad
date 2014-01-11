class AddOccasionIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products,:occasion_id,:integer,:default=>0
  end

  def self.down
    remove_column :products,:occasion_id
  end
end

