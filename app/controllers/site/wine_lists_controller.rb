class Site::WineListsController < ApplicationController
  before_filter :site_login_required
  
  layout 'site'
  
  def index
    @wine_lists = current_user.wine_lists.all
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @wine_list = current_user.wine_lists.create(:product_id => params[:product_id])
    
    respond_to do |format|
      format.html { redirect_back_or_default(wine_lists_path) }
    end
  end
  
  def destroy
    @wine_list = current_user.wine_lists.find_by_product_id(params[:id])
  end
end
