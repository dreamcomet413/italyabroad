class WineList < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  
  before_save :set_quantity
  
  def set_quantity
    # super
    self.quantity = 1 if self.quantity.blank?
  end
end
