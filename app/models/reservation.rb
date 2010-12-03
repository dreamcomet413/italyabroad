class Reservation < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  belongs_to :status_reservation
  
  validates_presence_of :date
  validates_uniqueness_of :user_id, :scope => [:date, :restaurant_id]
  validates_numericality_of :status_reservation_id
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
