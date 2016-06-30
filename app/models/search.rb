class Search
  attr_accessor :text, :region, :color, :grape, :organic, :vegetarian, :price, :category, :preparation_time, :recipe_type, :producer, :user, :difficulty, :mood

  def initialize(params = {})
    @text             = params[:text] ||= ""
    @region           = params[:region_id] ||= ""
    @color            = params[:color] ||= ""
    @grape            = params[:grape_id] ||= ""
    @organic          = params[:organic]||= ""
    @vegetarian       = params[:vegetarian] ||= ""
    @price            = params[:price] ||= ""
    @user             = params[:chef] ||= ""
    @recipe_type      = params[:recipe_type] ||= ""
    @difficulty       = params[:difficulty] ||= ""
    @preparation_time = params[:preparation_time] ||= ""
    @producer         = params[:producer_id] ||= ""
    @occasion         = params[:occasion_id] ||= ""
    @category         = params[:category].nil? ? nil : Category.find(params[:category])
    @user_id          = params[:chef] ||= ""
    @mood             = params[:mood] ||= ""
  end

  def conditions(products=true)
    text   = @text.gsub("'","''")
    text.strip!
    color  = @color.gsub("'","")
    color.upcase if color
    color.strip!

    conditions  = []
    conditions << "categories.name <> 'Events' AND categories.name <> 'Wine club'" if products
    conditions << "active = true"
    conditions << "categories.id = #{@category.id}" unless @category.blank?
    conditions << "products.name LIKE '%#{text}%'" if !text.blank? && products
    conditions << "vegetarian = 1" if !@vegetarian.blank? && @vegetarian == "1"
    conditions << "organic = 1" if !@organic.blank? && @organic == "1"
    conditions << "upper(color) LIKE '%#{color}%'" unless color.blank?
    conditions << "region_id = #{@region}" unless @region.blank?
    conditions << "producer_id = #{@producer}" unless @producer.blank?
    conditions << "product_prices.price #{price}" unless price.blank?
    conditions << "grapes.id = #{@grape}" unless grape.blank?
    conditions << "occasion_id = #{@occasion}" unless @occasion.blank?
    conditions << "moods.id = #{@mood}" unless @mood.blank?
    #conditions << "products.mood LIKE '%#{mood}%'" unless @mood.blank?
   # conditions << "products.quantity > 0"
    conditions = conditions.join(" AND ")
    conditions = nil if conditions.blank?
    return conditions
  end
  
  def conditions_for_recipes

    text = @text.gsub("'", "''")
    text.strip!
    conditions = []
    conditions << "recipes.name LIKE '%#{text}%'" unless text.blank?
    conditions << "active = #{true}"
    conditions << "preparation_time #{@preparation_time}" unless @preparation_time.blank?
    conditions << "recipe_type_id = #{@recipe_type}" unless @recipe_type.blank?
    conditions << "recipe_level_id = #{@difficulty}" unless @difficulty.blank?
    conditions << "user_id = #{@user_id}" unless @user_id.blank?
    conditions << "region_id = #{@region}" unless @region.blank?
    conditions << "mood_id = #{@mood}" unless @mood.blank?
    conditions = conditions.join(" AND ")
    conditions = nil if conditions.blank?
    return conditions
  end
  
  def self.get_products(product_type, params)
    category_ids = []
    category_ids = Category.where("name LIKE '%#{product_type}%'").collect &:id
    categorization_ids = Categorization.where('category_id IN (?)' , category_ids).map(&:product_id).uniq
    @products = Product.where("name like '%#{params[:term]}%' and id IN (?)" , categorization_ids).where(:active=>true).limit(10) 
    return @products
  end
  
end

