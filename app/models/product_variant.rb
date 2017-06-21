class ProductVariant < ActiveRecord::Base
  belongs_to :product
  belongs_to :variant , class_name: "Product" , foreign_key: 'variant_id' 
  before_destroy :check_roles
  after_save :add_variant_to_dependents
  def add_variant_to_dependents

  	if ProductVariant.where(product_id: self.variant_id, variant_id: self.product_id).blank?
  		
  		ProductVariant.create(product_id: self.variant_id, variant_id: self.product_id) 
  	end
  end

end
