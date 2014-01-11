class AboutU < ActiveRecord::Base
   belongs_to :image, :class_name => "Image", :foreign_key => "image_id",:dependent => :destroy
end