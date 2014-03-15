class CreateFoodOrDrinks < ActiveRecord::Migration
  def self.up
    create_table :food_or_drinks do |t|
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :food_or_drinks
  end
end
