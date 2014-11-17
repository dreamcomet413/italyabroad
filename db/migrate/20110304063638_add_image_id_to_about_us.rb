class AddImageIdToAboutUs < ActiveRecord::Migration
  def self.up
    add_column :about_us,:image_id,:integer unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :about_us,:image_id
  end
end

