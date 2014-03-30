class FoodOption < ActiveRecord::Base
  attr_accessible :title

  has_and_belongs_to_many :food_or_drinks
  has_and_belongs_to_many :desired_expenditures
end
