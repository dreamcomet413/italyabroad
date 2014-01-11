class ProductCorrelation < ActiveRecord::Base
  belongs_to :product
  belongs_to :correlation, :class_name => "Product", :foreign_key => "correlation_id"
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
