class NewsLetter < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :description
  
  belongs_to :status_news_letter
  belongs_to :news_letter_type
  
  has_many :news_letters_products, :dependent => :destroy
  has_many :products, :through => :news_letters_products
  
  belongs_to :header,  :class_name => "Image", :foreign_key => "header_id"
  belongs_to :image_1, :class_name => "Image", :foreign_key => "image_1_id"
  belongs_to :image_2, :class_name => "Image", :foreign_key => "image_2_id"
  belongs_to :image_3, :class_name => "Image", :foreign_key => "image_3_id"
  belongs_to :image_4, :class_name => "Image", :foreign_key => "image_4_id"
  belongs_to :image_5, :class_name => "Image", :foreign_key => "image_5_id"
  belongs_to :image_6, :class_name => "Image", :foreign_key => "image_6_id"
  belongs_to :image_7, :class_name => "Image", :foreign_key => "image_7_id"
  belongs_to :image_8, :class_name => "Image", :foreign_key => "image_8_id"
  
  validates_format_of :link_1, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix , :message => "is not vaid url, must contain http://"
  validates_format_of :link_2, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix , :message => "is not vaid url, must contain http://"
  validates_format_of :link_3, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix , :message => "is not vaid url, must contain http://"
  validates_format_of :link_4, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix , :message => "is not vaid url, must contain http://"
  validates_format_of :link_5, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix , :message => "is not vaid url, must contain http://"
  validates_format_of :link_6, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix , :message => "is not vaid url, must contain http://"
  validates_format_of :link_7, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix , :message => "is not vaid url, must contain http://"
  validates_format_of :link_8, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix , :message => "is not vaid url, must contain http://"
  
  def product_ids=(ids)
    ids = [ids] unless ids.kind_of? Array
    
    news_letters_products.each do |news_letters_product|
      news_letters_product.destroy unless ids.include? news_letters_product.product_id
    end
    
    ids.each do |id|
      self.news_letters_products.create(:product_id => id) unless news_letters_products.any? { |d| d.product_id == id }
    end
  end
  
  def product_ids
    ids = []
    news_letters_products.each do |news_letters_product|
      ids << news_letters_product.product_id unless news_letters_product.product_id.blank?
    end
    return ids
  end
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
