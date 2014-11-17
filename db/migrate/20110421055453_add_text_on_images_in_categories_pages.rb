class AddTextOnImagesInCategoriesPages < ActiveRecord::Migration
  def self.up
    add_column :categories,:text_on_image,:string unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :categories,:text_on_image
  end
end

