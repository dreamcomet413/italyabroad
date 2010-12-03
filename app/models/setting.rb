class Setting < ActiveRecord::Base
  belongs_to :wine_pdf,     :class_name => "Resource",  :foreign_key => "wine_pdf_id"
  belongs_to :home_image_1,   :class_name => "Image",     :foreign_key => "home_image_1_id"
  belongs_to :home_image_2,   :class_name => "Image",     :foreign_key => "home_image_2_id"
  belongs_to :home_image_3,   :class_name => "Image",     :foreign_key => "home_image_3_id"
  belongs_to :home_image_4,   :class_name => "Image",     :foreign_key => "home_image_4_id"
  belongs_to :home_image_5,   :class_name => "Image",     :foreign_key => "home_image_5_id"
  
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
end
