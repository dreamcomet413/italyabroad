class Restaurant < ActiveRecord::Base
  #acts_as_reviewer     commented by Sujith

  validates_presence_of :name, :message => "of resturant can't be blank"
  validates_numericality_of :cost, :allow_nil => true, :message => "is not a number"

  belongs_to :image_1, :class_name => "Image", :foreign_key => "image_1_id"
  belongs_to :image_2, :class_name => "Image", :foreign_key => "image_2_id"
  belongs_to :image_3, :class_name => "Image", :foreign_key => "image_3_id"

  belongs_to :resource_1, :class_name => "Resource", :foreign_key => "resource_1_id"
  belongs_to :resource_2, :class_name => "Resource", :foreign_key => "resource_2_id"
  belongs_to :resource_3, :class_name => "Resource", :foreign_key => "resource_3_id"

  #acts_as_sluggable :with => :name      commented by Sujith

  def page_title_formatted
    page_title.blank? ? name : page_title
  end

  def meta_description_formatted
    meta_description.blank? ? description[0..500] : meta_description
  end

  def meta_keys_formatted
    if meta_keys.blank?
      keys = []
      i = 0
      for key in description.downcase.split
        i += 1
        keys << key.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/-+$/, '').gsub(/^-+$/, '') unless keys.include?(key) || i > 21 || key.length < 4
      end
      return keys.collect.join(", ")
    else
      return meta_keys
    end
  end

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

