class Image <  ActiveRecord::Base
  has_many :producers
  has_many :grapes
  has_many :regions
  has_many :about_us,:dependent=>:destroy

  mount_uploader :image_filename, ProductUploader

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
