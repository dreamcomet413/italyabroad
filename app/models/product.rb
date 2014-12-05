class Product < ActiveRecord::Base
  validates_presence_of :name, :message => "of product can't be blank"
  validates_presence_of :code, :message => "can't be blank"

  #validates_numericality_of :price, :message => "is not a number"
  validates_numericality_of :from_quantity_price, :message => "is not a number"
  validates_numericality_of :from_quantity, :message => "is not a number"
  validates_numericality_of :cost, :message => "is not a number"
  validates_numericality_of :discount, :message => "is not a number"
  #validates_numericality_of :quantity, :message => "is not a number"

  # validates_uniqueness_of :name, :message => "of product must be unique"
  validates_uniqueness_of :code, :message => "must be unique"

  has_many :product_sizes
  has_many :product_prices, :dependent => :destroy
  attr_accessor :price, :quantity

  has_many :categorizations, :dependent => :destroy
  has_many :categories, :through => :categorizations

  has_many :product_correlations
  has_many :correlations, :through => :product_correlations

  has_many :product_includeds
  has_many :included_products, :through => :product_includeds

  has_many :news_letters_products, :dependent => :destroy
  has_many :news_letters, :through => :news_letters_products

  has_many :wish_lists, :dependent => :destroy
  has_many :order_items
  has_many :products_grapes
  has_many :grapes, :through => :products_grapes

  belongs_to :ideal_with, :class_name => "Product", :foreign_key => "ideal_with_id"
  belongs_to :how_to_cook, :class_name => "Recipe", :foreign_key => "how_to_cook_id"
  belongs_to :producer
  belongs_to :region
  belongs_to :occasion

  belongs_to :image_1, :class_name => "Image"
  belongs_to :image_2, :class_name => "Image", :foreign_key => "image_2_id"
  belongs_to :image_3, :class_name => "Image", :foreign_key => "image_3_id"

  belongs_to :resource_1, :class_name => "Resource", :foreign_key => "resource_1_id"
  belongs_to :resource_2, :class_name => "Resource", :foreign_key => "resource_2_id"
  belongs_to :resource_3, :class_name => "Resource", :foreign_key => "resource_3_id"

  has_and_belongs_to_many :cupons
  has_and_belongs_to_many :moods
  has_and_belongs_to_many :wine_sizes

  has_many :reviews, :as => :reviewer, :dependent => :destroy

  friendly_identifier :name

  after_create :make_product_prices

  scope :featured, :conditions => {:featured => true}, :limit => 5
  scope :on_offer, :conditions => ["active = ? AND discount > ?", true, 0], :limit => 5, :order => "RAND()"
  scope :other_events, lambda { |product|
    { :conditions => ["categories.name LIKE 'Events' AND products.id <> ? AND DATE(products.date) > ? AND active", product.id, Date.today], :include => {:categorizations => :category}, :order => "date", :limit => 3 }
  }

  LIMITED_QUANTITY = 24

  def make_product_prices
    temp = self.product_prices.build
    temp.price = price ||= 0
    temp.quantity = quantity ||= 1
    temp.save
  end

  def name_short(len)
    len ||= 20
    name >= len ? name[0,len] + " ..." : name
  end

  def multiple?
    return self.product_prices.size > 1
  end

  def self.grapes(category, search=nil)
    grapes = [[" Any",""]]
    for i in (1..6)
      conditions  = "products.id IN (#{category.all_products_ids.join(",")})"
      conditions += " AND " if search && !search.conditions.blank?
      conditions += search.conditions if search && !search.conditions.blank?

      self.find(:all, :include => :categories, :conditions => conditions ).group_by(&"grape_color_#{i}".to_sym).each do |t,  product|
        grape = t.strip if !t.blank?
        grapes  << [grape, grape] if !grape.blank? && !grapes.include?([grape, grape])
      end
    end
    return grapes.sort
  end

  def self.regions(category, search=nil)
    regions = [[" Any",""]]
    conditions  = "products.id IN (#{category.all_products_ids.join(",")})"
    conditions += " AND " if search && !search.conditions.blank?
    conditions += search.conditions if search && !search.conditions.blank?

    self.find(:all, :include => :categories, :conditions => conditions ).group_by(&:region).each do |t,  product|
      region = t.strip if !t.blank?
      regions  << [region, region] if !region.blank? && !regions.include?([region, region])
    end
    return regions.sort
  end

  def self.colors(category, search=nil)
    colors = [[" Any",""]]
    conditions = ""
    conditions  += "products.id IN (#{category.all_products_ids.join(",")})" unless category.all_products_ids.blank?
    conditions += " AND " if search && !search.conditions.blank? and !category.all_products_ids.blank?
    conditions += search.conditions if search && !search.conditions.blank?

    where(conditions).includes([:categories, :grapes]).group_by(&:color).each do |t, product|
    #find(:all, :include => [:categories, :grapes], :conditions => conditions ).group_by(&:color).each do |t,  product|
 # self.find(:all, :include => [:categories, :grapes], :conditions => conditions ).group_by(&:color).each do |t,  product|

      color = t.strip if !t.blank?
      color = color.gsub("'","") if color
      color = color.capitalize if color
      colors  << [color, color] if !color.blank? && !colors.include?([color, color])
    end
    return colors.sort
  end

  def page_title_formatted
    page_title.blank? ? name : page_title
  end

  def meta_description_formatted
    meta_description.blank? ? description_short : meta_description
  end

  def meta_keys_formatted
    if meta_keys.blank?
      keys = []
      i = 0
      for key in description.downcase.split
        i += 1
        keys << key.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/-+$/, '').gsub(/^-+$/, '') unless keys.include?(key) || i > 21 || key.length < 4
      end
      return keys.collect.to_a.join(", ")
    else
      return meta_keys
    end
  end

  def discounted?
    self.discount > 0
  end

  def price_discounted
    if (discount.to_i > 0 && product_prices.present?)
      price = []
      product_prices.each do |pp|
        price << pp.price.to_f - (pp.price.to_f * discount / 100)
      end
      return price
    else
      product_prices.map(&:price)
    end
  end

  def discounted_price(actual_price)
    if discount.to_i > 0
      return actual_price.to_f - (actual_price.to_f * discount / 100)
    else
      return actual_price.to_f
    end
  end

  def discounted_prices
    self.product_prices.map(&:price).collect do |p|
      self.discount.to_i > 0 ? [(p.to_f - (p.to_f * self.discount / 100)), p.to_f] : [p.to_f, p.to_f]
    end
  end

  def vat
  #  if rate == "17.5%"
   # 	return price_discounted / 1.175
    #	else
  	# return price_discounted
    #	end

  if rate == "0%"
  	   return price_discounted.first
  else
     	return price_discounted.first / (1 + (rate.to_f)/100) if rate != "0%"
  end
  end


  def price_per_bottle
    if price_discounted.present?
      price_discounted.each do |price|
    	  return price - from_quantity_price / from_quantity_price
      end
    else
      return self.product_prices.first.price
    end
  end

  def root_category(object = false)
    if categories && categories.size > 0 && categories.root
      return categories.root.name unless object
      return categories.root
    end
  end

  def sub_categories(object = false)
    tmp = []
    categories.each do |t|
      if object
        tmp << t unless t.root?
      else
        unless t.blank?
          tmp << t.name unless t.root?
        end
      end
    end
    return tmp
  end


  def root_category_id
    root_cat = root_category(true)
    root_cat.friendly_identifier unless root_cat.nil?
  end

  def sub_category_id
    sub_cat = sub_categories(true).first
    sub_cat.friendly_identifier unless sub_cat.nil?
  end

  def is_wine?
    RAILS_DEFAULT_LOGGER.debug "----> #{root_category}"
    root_category == "Wine" || root_category == "Other Drinks"
  end

  def is_food?
    RAILS_DEFAULT_LOGGER.debug "----> #{root_category}"
    root_category == "Food"
  end

  def unique_categories
    tmp = []
    categories.each {|t| tmp << t unless tmp.include?(t)}
    return tmp
  end

  def layout
    return categories.root.layout_card if categories && categories.size > 0 && categories.root
  end

  def layout_image
    return categories.root.layout_image if categories && categories.size > 0 && categories.root
  end

  def category_ids=(ids)
    ids = [ids] unless ids.kind_of? Array

    categorizations.each do |categorization|
      categorization.destroy unless ids.include? categorization.category_id
    end

    ids.each do |id|
      self.categorizations.create(:category_id => id) unless categorizations.any? { |d| d.category_id == id }
    end
  end

  def category_ids
    ids = []
    categorizations.each do |categorization|
      ids << categorization.category_id unless categorization.category_id.blank?
    end
    return ids
  end

  def correlation_ids=(ids)
    ids = [ids] unless ids.kind_of? Array

    product_correlations.each do |product_correlation|
      product_correlation.destroy unless ids.include? product_correlation.correlation_id
    end

    ids.each do |id|
      self.product_correlations.create(:correlation_id => id) unless product_correlations.any? { |d| d.correlation_id == id }
    end
  end

  def correlation_ids
    ids = []
    product_correlations.each do |product_correlation|
      ids << product_correlation.correlation_id unless product_correlation.correlation_id.blank?
    end
    return ids
  end

  def wine_name
    return "#{vintage} #{name}".strip
  end

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end

  def related_products
    unless self.cupons.nil? or self.cupons.empty?
      coupon_ids = self.cupons.map{|c| c.cupon_id.to_i}
      related = coupon_ids.map {|c| Cupon.find(c).products if Cupon.find(c).public? }
      related = related.flatten.compact - [self]
    end
    related
  end

  def out_of_stock?
    #quantity = self.quantity.is_a?(String) ? self.quantity.split(",").first.to_i : self.quantity
    #quantity == 0 or quantity < 0
    self.product_prices.empty?
  end

	# Calculates the average rating. Calculation based on the already given scores.
	def average_rating
	  reviews = self.reviews.find(:all,:conditions=>['publish = true  && score is not null '])
		return 0 if reviews.empty?
	#	( self.reviews.inject(0){|total, r| total += r.score.to_f }.to_f / reviews.size )
	(reviews.inject(0){|total, r| total += r.score.to_f }.to_f / reviews.size )
	end

	# Rounds the average rating value.
	def average_rating_round
		average_rating.round
	end
end

