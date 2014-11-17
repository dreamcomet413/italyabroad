class AddDescOfFoodAndProductOfTheWeek < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == "production"
      add_column :settings,:desc_wine_of_the_week,:string
      add_column :settings,:desc_food_of_the_week,:string
    end
  end

  def self.down
    remove_column :settings,:desc_wine_of_the_week
    remove_column :settings,:desc_food_of_the_week
  end
end

