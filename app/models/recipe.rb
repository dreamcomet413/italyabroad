class Recipe < ActiveRecord::Base
  validates_presence_of :name,:ingredients, :message => "of recipe can't be blank"
#  validates_presence_of :preparation, :message => "gdsgdhsdgf"
  validates_numericality_of :preparation_time
  validate do |user|
    user.errors.add_to_base("Cooking Instructions is not blank") if user.preparation.blank?
  end
  belongs_to :image_1, :class_name => "Image", :foreign_key => "image_1_id"
  belongs_to :image_2, :class_name => "Image", :foreign_key => "image_2_id"
  belongs_to :image_3, :class_name => "Image", :foreign_key => "image_3_id"

  belongs_to :resource_1, :class_name => "Resource", :foreign_key => "resource_1_id"
  belongs_to :resource_2, :class_name => "Resource", :foreign_key => "resource_2_id"
  belongs_to :resource_3, :class_name => "Resource", :foreign_key => "resource_3_id"

  has_many :recipe_correlations
  has_many :correlations, :through => :recipe_correlations
  has_many :reviews, :as => :reviewer, :dependent => :destroy

  belongs_to :product
  belongs_to :recipe_level
  belongs_to :recipe_type
  belongs_to :user
  belongs_to :region




  friendly_identifier :name

  scope :active, :conditions => {:active => true}
  scope :recommended, :conditions => {:raccomanded => true}
  scope :latest, :order => ["created_at DESC"]
  scope :most_viewed, :order => ["view_count DESC"]

  def self.most_viewed_recipes
    Recipe.where(['id NOT IN (?) and active = ?', Recipe.where(['active=true']).order('created_at DESC').limit(3),true]).order('view_count DESC')
  end

  def preparation_cleared
    self.preparation.to_s.gsub("\n","<br />")
  end

  def count_view
    self.view_count += 1
    self.save(false)
  end

  def self.users(search = nil)
    conditions = search ? search.conditions_for_recipes : nil
    users = [[" Any", ""]]
    self.find(:all, :include => :user, :conditions => conditions).each do |r|
      users << [r.user.name, r.user.id.to_s] if !r.user.nil? && !users.include?([r.user.name, r.user.id.to_s])
    end
    return users
  end
  def self.regions(search = nil)
    conditions = search ? search.conditions_for_recipes : nil
    regions = [[" Any", ""]]
    self.find(:all, :include => :region, :conditions => conditions).each do |r|
      regions << [r.region.name, r.region.id.to_s] if !r.region.nil? && !regions.include?([r.region.name, r.region.id.to_s])
    end
    return regions
  end




  def self.difficulties(search = nil)
    conditions = search ? search.conditions_for_recipes : nil
    difficulties = [[" Any", ""]]
    self.find(:all, :include => :recipe_level, :conditions => conditions).each do |r|
      difficulties << [r.recipe_level.name, r.recipe_level.id.to_s] if !r.recipe_level.nil? && !difficulties.include?([r.recipe_level.name, r.recipe_level.id.to_s])
    end
    return difficulties
  end

  def self.recipe_types(search = nil)
    conditions = search ? search.conditions_for_recipes : nil
    recipe_types = [[" Any",""]]
    self.find(:all, :include => :recipe_type, :conditions => conditions).group_by(&:recipe_type).each do |t,  recipes|
      recipe_types  << [t.name, t.id.to_s] if !recipe_types.include?([t.name, t.id.to_s])
    end
    return recipe_types
  end

  def self.preparation_times(search=nil)
    conditions = search ? search.conditions_for_recipes : nil
    preparation_times = [[" Any",""]]
    self.find(:all, :include => :recipe_type, :conditions => conditions).group_by(&:preparation_time).each do |t,  recipes|
      preparation_times  << [t.to_s, t.to_s] if !preparation_times.include?([t.to_s, t.to_s])
    end
    return preparation_times.sort
  end

  def page_title_formatted
    page_title.blank? ? name : page_title
  end

  def meta_description_formatted
    meta_description.blank? ? preparation[0..500] : meta_description
  end

  def meta_keys_formatted
    if meta_keys.blank?
      keys = []
      i = 0
      for key in preparation.downcase.split
        i += 1
        keys << key.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/-+$/, '').gsub(/^-+$/, '') unless keys.include?(key) || i > 21 || key.length < 4
      end
      return keys.collect.join(", ")
    else
      return meta_keys
    end
  end

  def correlation_ids=(ids)
    ids = [ids] unless ids.kind_of? Array

    recipe_correlations.each do |recipe_correlation|
      recipe_correlation.destroy unless ids.include? recipe_correlation.product_id
    end

    ids.each do |id|
      self.recipe_correlations.create(:product_id => id) unless recipe_correlations.any? { |d| d.product_id == id }
    end
  end

  def correlation_ids
    ids = []
    recipe_correlations.each do |recipe_correlation|
      ids << recipe_correlation.product_id unless recipe_correlation.product_id.blank?
    end
    return ids
  end

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end

  def all_product_with_that_are_related
    Product.find(:all).inject([]) do |products, product|
      products << {:product => product, :checked => self.correlation_ids.include?(product.id)}
    end
  end

  # Calculates the average rating. Calculation based on the already given scores.
  def average_rating
    return 0 if reviews.empty?
    ( self.reviews.inject(0){|total, r| total += r.score.to_f }.to_f / reviews.size )
  end

  # Rounds the average rating value.
  def average_rating_round
    average_rating.round
  end
end

