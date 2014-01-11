class PaymentMethod < ActiveRecord::Base
  validates_presence_of :name, :vendor
  has_many :orders
end
