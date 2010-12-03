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
      if @searched_text.length > 3
        @users = User.find(:all, :conditions => ["name LIKE ?", "%#{params[:text]}%"]).paginate(:page => params[:page], :per_page => 10)
      end

      respond_to do |format|
        format.html { render :action => :peoples }
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

  private
  def available_categories
    ["wine", "food", "hampers", "recipe", "people"]
  end

  def available_sorting
    ["price asc", "price desc", "name", "region_id"]
  end
end
