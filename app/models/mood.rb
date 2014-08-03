class Mood < ActiveRecord::Base
  has_and_belongs_to_many :products
  
  validates_presence_of :name
  validates_uniqueness_of :name

  mount_uploader :image, ImageUploader

end