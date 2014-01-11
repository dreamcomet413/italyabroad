class AddVegetarianToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :vegetarian, :boolean, :default => false
  end

  def self.down
    remove_column :recipes, :vegetarian
  end
end
