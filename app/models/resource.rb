class Resource < ActiveRecord::Base

  mount_uploader :filename, ProductUploader

  validates_size_of :filename, maximum: 2.megabytes, message: "should be less than 2 MB"

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
