class AddViewCountToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :view_count, :integer, :default => 0
    add_column :recipes, :user_id, :integer
    add_column :recipes, :serves, :string
  end

  def self.down
    remove_column :recipes, :view_count
    remove_column :recipes, :user_id
    remove_column :recipes, :serves
  end
end
