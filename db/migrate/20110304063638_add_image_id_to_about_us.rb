class AddImageIdToAboutUs < ActiveRecord::Migration
  def self.up
    add_column :about_us,:image_id,:integer
  end

  def self.down
    remove_column :about_us,:image_id
  end
end

