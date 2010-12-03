class AttributeSet < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :attributions, :dependent => :destroy
  has_many :attribute_items, :through => :attributions 
  
  def attribute_item_ids=(ids)
    ids = [ids] unless ids.kind_of? Array
    
    attributions.each do |attribution|
      attribution.destroy unless ids.include? attribution.attribute_item_id
    end
    
    ids.each do |id|
      self.attributions.create(:attribute_item_id => id) unless attributions.any? { |d| d.attribute_item_id == id }
    end
  end
  
  def attribute_item_ids
    ids = []
    attributions.each do |attribution|
      ids << attribution.attribute_item_id unless attribution.attribute_item_id.blank?
    end
    return ids
  end
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
