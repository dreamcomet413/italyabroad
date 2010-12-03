class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :product
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
