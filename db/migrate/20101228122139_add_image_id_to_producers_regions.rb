class AddImageIdToProducersRegions < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :producers,:image_id,:integer unless column_exists?(:producers, :image_id)
      add_column :regions,:image_id,:integer unless column_exists?(:regions, :image_id)
    #end
  end

  def self.down
    remove_column :producers,:image_id
    remove_column :regions,:image_id
  end
end

