class ShipAddress < ActiveRecord::Base
  attr_accessor :is_new

  validates_presence_of :code
  validates_presence_of :name
  validates_presence_of :address
  validates_presence_of :cap
  validates_presence_of :city
  validates_presence_of :country
  
  belongs_to :user
  
  
  def show_errors
    return ("- " + self.errors.full_messages.join("<br />- ")).html_safe()
  end
end

