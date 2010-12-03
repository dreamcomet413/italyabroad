class AddViewCountOnPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :friendly_identifier, :string
    add_column :posts, :view_count, :integer, :default => 0
  end

  def self.down
    remove_column :posts, :friendly_identifier
    remove_column :posts, :view_count
  end
end
