class AddMealAndWineToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:fav_meals,:string,:limit=>100
    add_column :users,:fav_wine,:string,:limit=>100
  end

  def self.down
    remove_column :users,:fav_meals
    remove_column :users,:fav_wine
  end
end

