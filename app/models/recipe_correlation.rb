class RecipeCorrelation < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :correlation, :class_name => "Product", :foreign_key => "product_id"
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
