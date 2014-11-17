class AddPageHeadingToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories,:page_heading,:string unless column_exists?(:categories, :page_heading)
  end

  def self.down
    remove_column :categories,:page_heading
  end
end

