class AddPageHeadingToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories,:page_heading,:string unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :categories,:page_heading
  end
end

