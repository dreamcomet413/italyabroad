class ProductPrice < ActiveRecord::Base
  
  belongs_to :product
  validates_numericality_of :price
  validates_numericality_of :quantity
  validates_presence_of :product_id

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end

end
