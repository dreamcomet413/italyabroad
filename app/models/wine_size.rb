class WineSize < ActiveRecord::Base
  attr_accessible :title

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :products
  has_and_belongs_to_many :food_or_drinks
end
