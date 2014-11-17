class AddDescOfFoodAndProductOfTheWeek < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :settings,:desc_wine_of_the_week,:string unless column_exists?(:orders, :desc_wine_of_the_week)
      add_column :settings,:desc_food_of_the_week,:string unless column_exists?(:orders, :desc_food_of_the_week)
    #end
  end

  def self.down
    remove_column :settings,:desc_wine_of_the_week
    remove_column :settings,:desc_food_of_the_week
  end
end

