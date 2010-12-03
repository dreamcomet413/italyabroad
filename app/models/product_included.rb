class ProductIncluded < ActiveRecord::Base
  belongs_to :product
  belongs_to :included_product, :class_name => "Product", :foreign_key => "included_product_id"

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
