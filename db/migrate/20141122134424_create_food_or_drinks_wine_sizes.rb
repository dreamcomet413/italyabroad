class CreateFoodOrDrinksWineSizes < ActiveRecord::Migration
  def self.up
    create_table :food_or_drinks_wine_sizes, :id => false do |t|
      t.integer :food_or_drink_id
      t.integer :wine_size_id
    end
  end

  def self.down
    drop_table :food_or_drinks_wine_sizes
  end
end
