class Resource < ActiveRecord::Base
  has_attachment :max_size => 10.megabytes, :storage => :file_system, :path_prefix => 'public/resources/files'
  validates_as_attachment
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
