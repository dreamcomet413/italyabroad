class StatusReservation < ActiveRecord::Base
  has_many :reservation
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
