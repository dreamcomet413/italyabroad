class AddColumnSommelierColumnsIntoProducts < ActiveRecord::Migration
  def self.up
    add_column :categories, :WineSizeids, :string
    add_column :categories, :FoodOrDrinkids, :string
    add_column :categories, :DesiredExpenditureids, :string
    add_column :categories, :FoodOptionids, :string
  end

  def self.down
    remove_column :categories, :FoodOptionids
    remove_column :categories, :DesiredExpenditureids
    remove_column :categories, :FoodOrDrinkids
    remove_column :categories, :WineSizeids
  end
end
