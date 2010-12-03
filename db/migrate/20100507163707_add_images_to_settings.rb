class AddImagesToSettings < ActiveRecord::Migration
  def self.up
    rename_column :settings, :home_image_id, :home_image_1_id
    add_column :settings, :home_image_2_id, :integer
    add_column :settings, :home_image_3_id, :integer
    add_column :settings, :home_image_4_id, :integer
    rename_column :settings, :home_image_url, :home_image_1_url
    add_column :settings, :home_image_2_url, :string
    add_column :settings, :home_image_3_url, :string
    add_column :settings, :home_image_4_url, :string
    add_column :settings, :home_image_1_title, :string
    add_column :settings, :home_image_2_title, :string
    add_column :settings, :home_image_3_title, :string
    add_column :settings, :home_image_4_title, :string
  end

  def self.down
    remove_column :settings, :home_image_4_title
    remove_column :settings, :home_image_3_title
    remove_column :settings, :home_image_2_title
    remove_column :settings, :home_image_1_title
    remove_column :settings, :home_image_4_url
    remove_column :settings, :home_image_3_url
    remove_column :settings, :home_image_2_url
    rename_column :settings, :home_image_1_url, :home_image_url
    remove_column :settings, :home_image_4_id
    remove_column :settings, :home_image_3_id
    remove_column :settings, :home_image_2_id
    rename_column :settings, :home_image_1_id, :home_image_id
  end
end
