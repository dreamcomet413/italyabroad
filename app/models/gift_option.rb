class GiftOption < ActiveRecord::Base
  validates_numericality_of :price
  validates_presence_of :name, :description
  
  has_many :orders
  
  def name_with_price
    return name + " £" + price.to_s
  end
  
  def validate
    errors.add('Price', 'must be greater than zero pound') if price <= 0 
  end
  
  def self.get_default
    if gift_option = self.find(:first, :conditions => ['is_default=?',true])
      return gift_option.id
    end
  end
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
