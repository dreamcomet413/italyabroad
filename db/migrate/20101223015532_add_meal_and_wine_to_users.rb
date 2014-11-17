class AddMealAndWineToUsers < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == "production"
      add_column :users,:fav_meals,:string,:limit=>100
      add_column :users,:fav_wine,:string,:limit=>100
    end
  end

  def self.down
    remove_column :users,:fav_meals
    remove_column :users,:fav_wine
  end
end

