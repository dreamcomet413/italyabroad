class Photo < ActiveRecord::Base

  mount_uploader :image_filename, ProductUploader

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

