class AddBodyToForumPosts < ActiveRecord::Migration
  def self.up
    add_column :forum_posts, :body, :text
    add_column :forum_posts, :body_html, :text
  end

  def self.down
    remove_column :forum_posts, :body
    remove_column :forum_posts, :body_html
  end
end
