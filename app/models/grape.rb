class Grape < ActiveRecord::Base
  belongs_to :image, :class_name => "Image", :foreign_key => "image_id",:dependent=>:destroy
  has_and_belongs_to_many :producers, :join_table => "grapes_producers", :foreign_key => "grape_id"
  has_many :products_grapes
  has_many :products, :through => :products_grapes

  friendly_identifier :name

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
      return keys.join(", ")
    else
      return meta_keys
    end
  end

end

