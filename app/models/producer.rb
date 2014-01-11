class Producer < ActiveRecord::Base
   belongs_to :image, :class_name => "Image", :foreign_key => "image_id",:dependent => :destroy
  has_and_belongs_to_many :grapes, :join_table => "grapes_producers", :foreign_key => "producer_id"
  belongs_to :region
  has_many :products

  friendly_identifier :name
end

