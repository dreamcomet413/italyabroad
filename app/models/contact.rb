class Contact < ActiveRecord::BaseWithoutTable
  apply_simple_captcha :message => " image and text were different", :add_to_base => true
  column :name, :string
  column :email, :string
  column :message, :text
  column :know_through, :string
  
  validates_presence_of :name, :message => "is not blank?"
  validates_format_of   :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end