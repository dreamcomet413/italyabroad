class Attribution < ActiveRecord::Base
  belongs_to :attribute_set
  belongs_to :attribute_item
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
