class WineList < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  
  def initialize(params={})
    super
    self.quantity = 1 if self.quantity.blank?
  end
end
