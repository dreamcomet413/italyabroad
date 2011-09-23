class Image <  ActiveRecord::Base
  has_many :producers
  has_many :grapes
  has_many :regions
  has_many :about_us,:dependent=>:destroy
  acts_as_fleximage do
    image_directory 'public/resources/images'
    image_storage_format :jpg
  end

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

