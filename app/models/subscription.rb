class Subscription < ActiveRecord::Base
  validates_presence_of     :email, :name, :surname
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_format_of       :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  after_create do |record|
    Notifier.deliver_subscribe(record.email)
  end
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
