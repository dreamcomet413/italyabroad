class AddPageHeadingToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories,:page_heading,:string
  end

  def self.down
    remove_column :categories,:page_heading
  end
end

