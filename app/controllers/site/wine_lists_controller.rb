class Site::WineListsController < ApplicationController
  before_filter :site_login_required

  layout 'site'

  def index

    @wine_lists = current_user.wine_lists.all

  end

  def create
  #  @wine_list = current_user.wine_lists.create(:product_id => params[:product_id])
  product = Product.find(params[:product_id])
     if logged_in?
      current_user.wine_lists.create(:product_id => product.id)
      render :js => "alert('#{product.name} correctly added to your wine list')"
    else
      render :js => "alert('You must login to add a product to your wine list')"
    end

  end

  def destroy

    current_user.wine_lists.find(params[:id]).destroy
    redirect_to :action => :index
  end
end

