class FoodOrDrink < ActiveRecord::Base
  has_and_belongs_to_many :wine_sizes
  has_and_belongs_to_many :desired_expenditures
  has_and_belongs_to_many :food_options
end
