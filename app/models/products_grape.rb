class ProductsGrape < ActiveRecord::Base
  belongs_to :product
  belongs_to :grape
end
