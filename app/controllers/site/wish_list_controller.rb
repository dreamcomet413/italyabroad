class Site::WishListController < ApplicationController
  before_filter :site_login_required, :only => [:index]
  before_filter :store_location

  layout "site"

  def index
    @wish_lists = current_user.wish_lists.find(:all,:order => "created_at DESC")
  end

  def create
    product = Product.find(params[:product_id])

    if logged_in?
      current_user.wish_lists.find_or_create_by_product_id(product.id)
      render :js => "alert('#{product.name} correctly added to your wish list')"
    else
      render :js => "alert('You must login to add a product to your wish list')"
    end
  end

  def destroy
    current_user.wish_lists.find(params[:id]).destroy
    redirect_to :action => :index
  end

end

