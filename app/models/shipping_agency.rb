class ShippingAgency < ActiveRecord::Base
  has_many :orders
end

