class AddImageIdToProducersRegions < ActiveRecord::Migration
  def self.up
    add_column :producers,:image_id,:integer
    add_column :regions,:image_id,:integer
  end

  def self.down
    remove_column :producers,:image_id
    remove_column :regions,:image_id
  end
end

