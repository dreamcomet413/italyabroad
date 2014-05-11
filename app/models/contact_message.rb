class ContactMessage < ActiveRecord::Base
  validates_presence_of :header, :message => "is not blank?"
  validates_presence_of :message, :message => "is not blank?"
  validates_format_of   :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
