class Image <  ActiveRecord::Base
  acts_as_fleximage do
    image_directory 'public/resources/images'
    image_storage_format :jpg
  end
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
