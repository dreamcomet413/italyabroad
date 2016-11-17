class AddMetaTagToAboutUs < ActiveRecord::Migration
  def change
    add_column :about_us, :meta_title, :string
    add_column :about_us, :meta_description, :string
  end
end
