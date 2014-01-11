class Occasion < ActiveRecord::Base
  validates_presence_of :name
  has_many :products
end

