class Site::WineListsController < ApplicationController
  before_filter :site_login_required, :only => [:index]
  before_filter :store_location
  layout 'site'

  def index

    @wine_lists = current_user.wine_lists.all

  end

  def create
  #  @wine_list = current_user.wine_lists.create(:product_id => params[:product_id])
  product = Product.find(params[:product_id])

     if logged_in?
        if current_user.wine_lists.count < AppConfig.wine_list_limit
        current_user.wine_lists.find_or_create_by_product_id(product.id)
        render :js => "alert('#{product.name} correctly added to your wine list')"
        else
          render :js => "alert('Not able to add more, your limit reached')"
        end
    else
      render :js => "alert('You must login to add a product to your wine list')"
    end

  end

  def destroy
    product = Product.find_by_friendly_identifier(params[:id])
    current_user.wine_lists.find_by_product_id(product.id).destroy
    redirect_to :action => :index
  end
end

