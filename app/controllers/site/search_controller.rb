class Site::SearchController < ApplicationController
  layout 'site'

  def index
    params[:category] ||= params[:id]
    @searched_text = params[:text]

    if params[:wine_type].present? || params[:body_type].present? || params[:price_type].present? || params[:food_type].present?
      @sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "product_prices.price asc"
      @sort_by = 'products.name' if @sort_by.to_s.upcase == 'NAME'

      if params[:price_type].present?
        #Under £10	Between £10 and £20	More than £20
        price_query_text = "? < 10" if params[:price_type] == "under 10"
        price_query_text = "? > 10 AND ? < 20" if params[:price_type] == "between 10 and 20"
        price_query_text = " ? > 20 " if params[:price_type] == "more than 20"
        price_query_text= price_query_text.gsub("?","product_prices.price")
      end
      @category =  Category.find_by_name(params[:wine_type]+"s")
      @products = @category.present? ? @category.products : Product.where("surprise_me = ?",true)
      @products = @products.where("products.body_type = ?",params[:body_type].to_s)  if params[:body_type].present?
      @products = @products.where("products.with_food_type like ?","%#{params[:food_type].to_s}%") if params[:food_type].present?
      @products = @products.joins(:product_prices).where(price_query_text) if params[:price_type].present?
      @products = @products.where("active = ?",true).order(@sort_by)
      @products = @products.paginate(:page => params[:page], :per_page => 10)
    elsif params[:category] == "recipe"
      @search = Search.new(params || {})
      @recipes = Recipe.where(@search.conditions_for_recipes).paginate(:page => params[:page], :per_page => 10)

      respond_to do |format|
        format.html { render :action => :recipes }
      end
    elsif params[:category] == "people"
      #  if @searched_text.length > 3
      @users = User.where("name LIKE ? AND city LIKE ?", "%#{params[:text]}%","%#{params[:city_text]}%").paginate(:page => params[:page], :per_page => 10)
      #  end

      respond_to do |format|
        format.html { render :action => :peoples }
      end

    elsif params[:category] == "chef"
      @type = Type.find(:first,:conditions=>['upper(name) = ?',params[:category].upcase])
      #  if @searched_text.length > 3
      @users = User.where("name LIKE ? AND type_id = ?", "%#{params[:text]}%",@type.id).paginate(:page => params[:page], :per_page => 10)
      #  end

      respond_to do |format|
        format.html { render :action => :peoples }
      end
      #-------------
    elsif params[:category] == "grape"
      #@type = Type.find(:first,:conditions=>['upper(name) = ?',params[:category].upcase])
      #  if @searched_text.length > 3
      @users = Grape.where("name LIKE ? ", "%#{params[:text]}%").paginate(:page => params[:page], :per_page => 10)
      #  end

      respond_to do |format|
        format.html { render :action => :grapes }
      end

      #-------------
    elsif params[:category] == "all"
      @search = Search.new(params || Hash.new)
      @recipes = Recipe.find(:all, :conditions =>     @search.conditions_for_recipes)

      @search = Search.new(params || Hash.new)

      wine_conditions = ["upper(categories.name) LIKE ? AND products.name LIKE ? #{('AND moods.id = ' + params[:mood].strip) if params[:mood.present?]} AND products.active = ? AND product_prices.quantity > ? ",'WINE',"%#{params[:text].strip}%", true,0]
      other_drinks_conditions = ["upper(categories.name) LIKE ? AND products.name LIKE ? #{('AND moods.id = ' + params[:mood].strip) if params[:mood.present?]} AND products.active = ? AND product_prices.quantity > ? ",'Other Drinks',"%#{params[:text].strip}%", true,0]
      hamper_conditions = ["upper(categories.name) LIKE ? AND products.name LIKE ? #{('AND moods.id = ' + params[:mood].strip) if params[:mood.present?]} AND products.active = ? AND product_prices.quantity > ? ",'HAMPERS',"%#{params[:text].strip}%", true,0]
      food_conditions = ["upper(categories.name) LIKE ? AND products.name LIKE ? #{('AND moods.id = ' + params[:mood].strip) if params[:mood.present?]} AND products.active = ? AND product_prices.quantity > ? ",'FOOD',"%#{params[:text].strip}%", true,0]
      wine_events_conditions = ["upper(categories.name) LIKE ? AND products.name LIKE ? #{('AND moods.id = ' + params[:mood].strip) if params[:mood.present?]} AND products.active = ?  AND DATE(date) >= ?", 'EVENTS', "%#{params[:text].strip}%", true, Date.today]
      @wines = Product.find(:all, :include => [:categories, :moods, :product_prices] ,:conditions => wine_conditions)
      @other_drinks = Product.find(:all, :include => [:categories, :moods, :product_prices] ,:conditions => other_drinks_conditions)
      @hampers = Product.find(:all, :include => [:categories, :moods, :product_prices] ,:conditions => hamper_conditions)
      @foods = Product.find(:all, :include => [:categories, :moods, :product_prices] ,:conditions => food_conditions)

      @wine_events = Product.find(:all, :include => [:categories, :moods, :product_prices] ,:conditions => wine_events_conditions)

      SearchQuery.create(:query => @search.text) unless (@wines.blank? or @foods.blank?)

      @users = User.find(:all, :conditions => ["name LIKE ?", "%#{params[:text]}%"])

      @producers = Producer.find(:all, :conditions => ["name LIKE ? AND active = ?", "%#{params[:text]}%",true])

      @grapes = Grape.find(:all, :conditions => ["name LIKE ? ", "%#{params[:text]}%"])

      respond_to do |format|
        format.html { render :action => :all }
      end

    else
      #@sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price DESC"

      @sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "product_prices.price asc"
      if @sort_by.to_s.upcase == 'NAME'
        @sort_by = 'products.name'
      end
      @search = Search.new(params || Hash.new)
      @category = @search.category
      @products = Product.where(@search.conditions).includes([:categories, :grapes, :moods, :product_prices]).order(@sort_by).paginate(:page => params[:page], :per_page => 10)
      SearchQuery.create(:query => @search.text) unless @products.blank?

      respond_to do |format|

        format.html
      end
    end
  end



  def find_users
    @users = User.where("name LIKE ?", "%#{params[:text]}%").paginate(:page => params[:page], :per_page => 10)

  end
  def find_producers
    @producers = Producer.where("name LIKE ? and active = ?", "%#{params[:text]}%",true).paginate(:page => params[:page], :per_page => 10)


  end


  def find_wines
    # @search = Search.new(params || Hash.new)
    @wines = Product.where(['products.name LIKE ? AND upper(categories.name) LIKE ? AND products.active = ? ',"%#{params[:text]}%",'WINE',true]).includes([:categories,:grapes, :product_prices]).paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
    end
  end

  def find_other_drinks
    # @search = Search.new(params || Hash.new)
    @other_drinks = Product.where(['products.name LIKE ? AND upper(categories.name) LIKE ? AND products.active = ? AND product_prices.quantity > ?',"%#{params[:text]}%",'OTHER DRINKS',true,0]).includes([:categories,:grapes, :product_prices]).paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
    end
  end

  def find_foods
    @foods = Product.where(['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ? AND product_prices.quantity > ?','FOOD',"%#{params[:text]}%",true,0]).includes([:categories,:grapes, :product_prices]).paginate(:page => params[:page], :per_page => 10)
  end

  def find_hampers
    @hampers = Product.where(['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ? AND product_prices.quantity > ?','HAMPERS',"%#{params[:text]}%",true,0]).includes([:categories, :product_prices]).paginate(:page => params[:page], :per_page => 10)

  end

  def find_recipes
    #  @recipes = Recipe.find(:all, :conditions => ['name LIKE ? AND active = ?',"%#{params[:text]}%",true]).paginate(:page => params[:page], :per_page => 10)
    @search = Search.new(params || Hash.new)
    @recipes = Recipe.where(@search.conditions_for_recipes).order(params[:sort_by]).paginate(:page => params[:page], :per_page => 10)
  end

  def find_wine_events
    @wine_events = Product.where(['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ?  AND DATE(date) >= ?','EVENTS',"%#{params[:text]}%",true,Date.today]).includes([:categories]).paginate(:page => params[:page], :per_page => 10)
  end

  def find_grapes
    @grapes = Grape.where('grapes.name LIKE ? ',"%#{params[:text]}%").paginate(:page => params[:page], :per_page => 10)
  end

  private
  def available_categories
    ["wine", "food", "hampers", "recipe", "people"]
  end

  def available_sorting
    ["product_prices.price asc", "product_prices.price desc", "name", "region_id"]
  end
end

