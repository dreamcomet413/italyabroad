class Grape < ActiveRecord::Base
  belongs_to :image
  has_and_belongs_to_many :producers, :join_table => "grapes_producers", :foreign_key => "grape_id"
  has_many :products_grapes
  has_many :products, :through => :products_grapes
  
  friendly_identifier :name
end
