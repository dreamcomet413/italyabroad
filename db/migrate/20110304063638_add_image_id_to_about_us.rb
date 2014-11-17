class AddImageIdToAboutUs < ActiveRecord::Migration
  def self.up
    add_column :about_us,:image_id,:integer unless column_exists?(:about_us, :image_id)
  end

  def self.down
    remove_column :about_us,:image_id
  end
end

