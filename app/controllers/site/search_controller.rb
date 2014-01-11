class Site::SearchController < ApplicationController
  layout 'site'

  def index

    params[:category] ||= params[:id]
    @searched_text = params[:text]

    if params[:category] == "recipe"
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
      #  @wines = Product.find(:all, :include => [:categories, :grapes] ,:conditions => @search.conditions)
      @wines = Product.find(:all, :include => [:categories] ,:conditions => ['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ? AND quantity > ? ','WINE',"%#{params[:text]}%",true,0])

      @hampers = Product.find(:all, :include => [:categories] ,:conditions => ['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ? AND quantity > ? ','HAMPERS',"%#{params[:text]}%",true,0])


      @foods = Product.find(:all, :include => [:categories] ,:conditions => ['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ? AND quantity > ? ','FOOD',"%#{params[:text]}%",true,0])

      @wine_events = Product.find(:all, :include => [:categories] ,:conditions => ['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ?  AND DATE(date) >= ?','EVENTS',"%#{params[:text]}%",true,Date.today])

      SearchQuery.create(:query => @search.text) unless (@wines.blank? or @foods.blank?)

      @users = User.find(:all, :conditions => ["name LIKE ?", "%#{params[:text]}%"])

      @producers = Producer.find(:all, :conditions => ["name LIKE ? AND active = ?", "%#{params[:text]}%",true])

      @grapes = Grape.find(:all, :conditions => ["name LIKE ? ", "%#{params[:text]}%"])

      respond_to do |format|
        format.html { render :action => :all }
      end

    else
      #@sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price DESC"

      @sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price ASC"
      if @sort_by.to_s.upcase == 'NAME'
        @sort_by = 'products.name'
      end
      @search = Search.new(params || Hash.new)
      @category = @search.category
      @products = Product.where(@search.conditions).includes([:categories, :grapes]).order(@sort_by).paginate(:page => params[:page], :per_page => 10)
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
    @wines = Product.where(['products.name LIKE ? AND upper(categories.name) LIKE ? AND products.active = ? AND quantity > ?',"%#{params[:text]}%",'WINE',true,0]).
        includes([:categories,:grapes]).paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
    end
  end

  def find_foods
    @foods = Product.where(['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ? AND products.quantity > ?','FOOD',"%#{params[:text]}%",true,0]).
        includes([:categories,:grapes]).paginate(:page => params[:page], :per_page => 10)
  end

  def find_hampers
    @hampers = Product.where(['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ? AND products.quantity > ?','HAMPERS',"%#{params[:text]}%",true,0]).
        includes([:categories]).paginate(:page => params[:page], :per_page => 10)

  end

  def find_recipes
    #  @recipes = Recipe.find(:all, :conditions => ['name LIKE ? AND active = ?',"%#{params[:text]}%",true]).paginate(:page => params[:page], :per_page => 10)
    @search = Search.new(params || Hash.new)
    @recipes = Recipe.where(@search.conditions_for_recipes).order(params[:sort_by]).paginate(:page => params[:page], :per_page => 10)
  end

  def find_wine_events
    @wine_events = Product.where(['upper(categories.name) LIKE ? AND products.name LIKE ? AND products.active = ?  AND DATE(date) >= ?','EVENTS',"%#{params[:text]}%",true,Date.today]).
        includes([:categories]).paginate(:page => params[:page], :per_page => 10)
  end

  def find_grapes
    @grapes = Grape.where('grapes.name LIKE ? ',"%#{params[:text]}%").
        paginate(:page => params[:page], :per_page => 10)
  end


  private
  def available_categories
    ["wine", "food", "hampers", "recipe", "people"]
  end

  def available_sorting
    ["price asc", "price desc", "name", "region_id"]
  end
end

