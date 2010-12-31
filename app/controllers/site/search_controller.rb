class Site::SearchController < ApplicationController
  layout 'site'

  def index
    params[:category] ||= params[:id]
    @searched_text = params[:text]

    if params[:category] == "recipe"
      @search = Search.new(params || {})
      @recipes = Recipe.find(:all, :conditions => @search.conditions_for_recipes).paginate(:page => params[:page], :per_page => 10)

      respond_to do |format|
        format.html { render :action => :recipes }
      end
    elsif params[:category] == "people"
    #  if @searched_text.length > 3
        @users = User.find(:all, :conditions => ["name LIKE ?", "%#{params[:text]}%"]).paginate(:page => params[:page], :per_page => 10)
    #  end

      respond_to do |format|
        format.html { render :action => :peoples }
      end

    elsif params[:category] == "chef"
      @type = Type.find(:first,:conditions=>['upper(name) = ?',params[:category].upcase])
    #  if @searched_text.length > 3
        @users = User.find(:all, :conditions => ["name LIKE ? AND type_id = ?", "%#{params[:text]}%",@type.id]).paginate(:page => params[:page], :per_page => 10)
    #  end

        respond_to do |format|
          format.html { render :action => :peoples }
        end
       elsif params[:category] == "all"
         @search = Search.new(params || Hash.new)
        @recipes = Recipe.find(:all, :conditions =>     @search.conditions_for_recipes)

      @search = Search.new(params || Hash.new)
      @wines = Product.find(:all, :include => [:categories, :grapes] ,:conditions => @search.conditions)

     @foods = Product.find(:all, :include => [:categories] ,:conditions => ['upper(categories.name) LIKE ? AND products.name LIKE ?','FOOD',"%#{params[:text]}%"])
    SearchQuery.create(:query => @search.text) unless (@wines.blank? or @foods.blank?)

      @users = User.find(:all, :conditions => ["name LIKE ?", "%#{params[:text]}%"])

      respond_to do |format|
        format.html { render :action => :all }
      end

    else
      @sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price DESC"
      @search = Search.new(params || Hash.new)
      @category = @search.category
      @products = Product.find(:all, :order => @sort_by, :include => [:categories, :grapes], :conditions => @search.conditions).paginate(:page => params[:page], :per_page => 10)
      SearchQuery.create(:query => @search.text) unless @products.blank?

      respond_to do |format|
        format.html
      end
    end
  end
  def find_users
      @users = User.find(:all, :conditions => ["name LIKE ?", "%#{params[:text]}%"])

    respond_to do |format|
      format.html{ render :update do |page|
        page.replace_html 'all_users',:partial=>'people',:object=>@users
      end
      }
    end
  end

  def find_wines
    @search = Search.new(params || Hash.new)
     @wines = Product.find(:all, :include => [:categories, :grapes] ,:conditions => @search.conditions)

     respond_to do |format|
      format.html{ render :update do |page|
        page.replace_html 'all_wines',:partial=>'wine',:object=>@wines
      end
      }
    end
  end

  def find_foods
       @foods = Product.find(:all, :include => [:categories,:grapes] ,:conditions => ['upper(categories.name) LIKE ? AND products.name LIKE ?','FOOD',"%#{params[:text]}%"])
     respond_to do |format|
      format.html{ render :update do |page|
        page.replace_html 'all_foods',:partial=>'all_foods',:object=>@foods
      end
      }
    end
  end
  def find_recipes
      @search = Search.new(params || {})

      @recipes = Recipe.find(:all, :conditions =>     @search.conditions_for_recipes)
     respond_to do |format|
      format.html{ render :update do |page|
        page.replace_html 'all_recipes',:partial=>'all_recipes',:object=>@recipes
      end
      }
    end
  end

  private
  def available_categories
    ["wine", "food", "hampers", "recipe", "people"]
  end

  def available_sorting
    ["price asc", "price desc", "name", "region_id"]
  end
end

