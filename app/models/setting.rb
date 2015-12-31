class Setting < ActiveRecord::Base
  belongs_to :wine_pdf,     :class_name => "Resource",  :foreign_key => "wine_pdf_id"
  belongs_to :home_image_1,   :class_name => "Image",     :foreign_key => "home_image_1_id"
  belongs_to :home_image_2,   :class_name => "Image",     :foreign_key => "home_image_2_id"
  belongs_to :home_image_3,   :class_name => "Image",     :foreign_key => "home_image_3_id"
  belongs_to :home_image_4,   :class_name => "Image",     :foreign_key => "home_image_4_id"
  belongs_to :home_image_5,   :class_name => "Image",     :foreign_key => "home_image_5_id"
  
  belongs_to :producers_image,    :class_name => "Image", :foreign_key => "producers_image_id"
  belongs_to :faqs_image,         :class_name => "Image", :foreign_key => "faqs_image_id"
  belongs_to :grape_guide_image,  :class_name => "Image", :foreign_key => "grape_guide_image_id"
  belongs_to :blog_image,         :class_name => "Image", :foreign_key => "blog_image_id"
  belongs_to :regions_image,      :class_name => "Image", :foreign_key => "regions_image_id"
  
  attr_accessor :home_page_1_title
  
  IMAGE_NAMES = %w{home_image_1 home_image_2 home_image_3 home_image_4 home_image_5}
  
  def self.order_amount
    s = Setting.find(:first)
    if s && s.order_amount > 0
      return s.order_amount
    else
      return 1
    end 
  end
  
  def self.order_delivery_amount
    s = Setting.find(:first)
    if s && s.order_delivery_amount > 0
      return s.order_delivery_amount
    else
      return 1
    end 
  end
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end

  def discount_suggestion?(number_of_wines)
    if self.try(:wine_discount_number).present? and self.try(:wine_discount_amount).present?
      return (number_of_wines >= self.wine_discount_number.to_i and self.wine_discount_number.to_i != 0 and self.wine_discount_amount != 0)
    end
  end
end
