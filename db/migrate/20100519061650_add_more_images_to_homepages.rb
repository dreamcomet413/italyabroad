class AddMoreImagesToHomepages < ActiveRecord::Migration
  def self.up
    add_column :settings, :home_image_5_id, :integer
    add_column :settings, :home_image_5_title, :string
    add_column :settings, :home_image_5_url, :string
  end

  def self.down
    remove_column :settings, :home_image_5_url
    remove_column :settings, :home_image_5_title
    remove_column :settings, :home_image_5_id
  end
end
