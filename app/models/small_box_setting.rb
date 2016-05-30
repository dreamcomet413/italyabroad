class SmallBoxSetting < ActiveRecord::Base
	belongs_to :image, :class_name => "Image", :foreign_key => "image_id",:dependent=>:destroy
	validates :box_title , uniqueness: true
	accepts_nested_attributes_for :image #, reject_if: proc { |attributes| attributes['image_filename'].blank? }
end
