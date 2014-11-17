class AddTextOnImagesInCategoriesPages < ActiveRecord::Migration
  def self.up
    add_column :categories,:text_on_image,:string unless column_exists?(:categories, :text_on_image)
  end

  def self.down
    remove_column :categories,:text_on_image
  end
end

