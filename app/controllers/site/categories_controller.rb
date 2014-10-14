class Site::CategoriesController < ApplicationController
  before_filter :store_location

  layout "site"

  def show
    if params[:category].nil? && %w(wine food hampers events wine-club).include?(params[:id]) # obsolete route
      headers["Status"] = "301 Moved Permanently"
      redirect_to "/#{params[:id]}"
      return
    end
    @category = Category.find(params[:category])
    @show = true
  end

  def show_sub
    if params[:category] != "offer"

      if params[:parent].blank? || params[:category].blank?
        redirect_to root_url and return
      else
        #@sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price DESC"
        @sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.id ASC"
        if @sort_by.to_s.upcase == 'NAME'
          @sort_by = 'products.name'
        end
        @category = Category.find(params[:category])

        unless @category.blank?
          @search = Search.new(params || Hash.new)
          @products = @category.blank? ?
              [] :
              @category.products.where(@search.conditions).includes([:categories, :grapes, :moods]).order(@sort_by).paginate(:page => (params[:page] ||=1), :per_page => 10)
          #@category.products.find(:all, :order => @sort_by, :include => [:categories, :grapes], :conditions => @search.conditions).
          #    paginate(:page => (params[:page] ||=1), :per_page => 10)
          SearchQuery.create(:query => @search.text) unless @search.text.blank?
        else
          @product = Product.find(:first,:conditions=>['friendly_identifier = ? AND mood= ?',params[:category], params[:mood]])
          unless @product.blank?
            redirect_to product_path(@product.friendly_identifier)
          else
            redirect_to root_url and return
          end
        end
      end
    else

      #@sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price DESC"
      @sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.id ASC"
      if @sort_by.to_s.upcase == 'NAME'
        @sort_by = 'products.name'
      end

      @category = Category.find(params[:parent])
      @search = Search.new(params || Hash.new)
#      @products = @category.blank? ? [] : @category.products.find(:all, :order => @sort_by, :include => [:categories, :grapes], :conditions => @search.conditions).paginate(:page => (params[:page] ||=1), :per_page => 10)
#@products = @category.blank? ? [] : @category.products.find(:all, :order => 'products.id desc', :include => [:categories, :grapes], :conditions => [@search.conditions << " and discount != 0"]).paginate(:page => (params[:page] ||=1), :per_page => 10)
      @products = @category.blank? ? [] : @category.products.where([@search.conditions << " and discount != 0"]).includes([:categories, :grapes]).
          order('products.id ASC').paginate(:page => (params[:page] ||=1), :per_page => 10)
      SearchQuery.create(:query => @search.text) unless @search.text.blank?
    end

  end

  def all_mixedcase_image
    @category = Category.find(params[:parent])
    #@sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price DESC"
    @sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price ASC"
    #      @category = Category.find(params[:category])
    @search = Search.new(params || Hash.new)
    @products = @category.blank? ? [] : @category.products.find(:all, :order => @sort_by, :include => [:categories, :grapes], :conditions => @search.conditions).paginate(:page => params[:page_no], :per_page => 10)

    render :update do|page|
      page.replace_html "other-image", :partial => "site/categories/mixedcase_images", :collections => @products
    end

  end

  def special_offer
    params[:parent]
    #@sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price DESC"
    @sort_by = available_sorting.include?(params[:sort_by]) ? params[:sort_by] : "products.price ASC"
    @category = Category.find(params[:category])
    @search = Search.new(params || Hash.new)
    @products = @category.blank? ? [] : @category.products.find(:all, :order => @sort_by, :include => [:categories, :grapes], :conditions => @search.conditions).paginate(:page => (params[:page] ||=1), :per_page => 10)
    @products = @category.blank? ? [] : @category.products.find(:all, :order => @sort_by, :include => [:categories, :grapes], :conditions => [@search.conditions && 'discount != ?','0.00']).paginate(:page => (params[:page] ||=1), :per_page => 10)
    SearchQuery.create(:query => @search.text) unless @search.text.blank?

  end

  private
  def available_sorting
    ["price asc", "price desc", "name", "region_id"]
  end
end

