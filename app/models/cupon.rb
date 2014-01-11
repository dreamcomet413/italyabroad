class Cupon < ActiveRecord::Base
  validates_numericality_of :price
  has_many :orders
  has_and_belongs_to_many :products
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
