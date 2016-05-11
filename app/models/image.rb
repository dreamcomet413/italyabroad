class Image <  ActiveRecord::Base
  has_many :producers
  has_many :grapes
  has_many :regions
  has_one :small_box_setting
  has_many :about_us,:dependent=>:destroy

  mount_uploader :image_filename, ProductUploader

  validates_size_of :image_filename, maximum: 2.megabytes, message: "should be less than 2 MB"

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
