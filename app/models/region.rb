class Region < ActiveRecord::Base
  belongs_to :image, :class_name => "Image", :foreign_key => "image_id",:dependent=>:destroy
  has_many :producers
  has_many :products
  has_many :recipes
  friendly_identifier :name
end

