class StatusOrder < ActiveRecord::Base
  has_many :orders
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
