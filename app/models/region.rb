class Region < ActiveRecord::Base
  has_many :producers
  has_many :products
  
  friendly_identifier :name
end
