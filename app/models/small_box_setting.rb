class SmallBoxSetting < ActiveRecord::Base
	belongs_to :image, :class_name => "Image", :foreign_key => "image_id",:dependent=>:destroy
	validates :box_title , uniqueness: true
end
