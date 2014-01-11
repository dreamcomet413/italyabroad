class AttributeItem < ActiveRecord::Base
  validates_presence_of :name, :section
  
  has_many :attributions, :dependent => :destroy
  has_many :attribute_sets, :through => :attributions
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
