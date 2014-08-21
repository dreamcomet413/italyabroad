class Admin::ResourcesController < ApplicationController
  before_filter :admin_login_required
  before_filter :get_instance_vars
  
  def destroy
    @resource.destroy
    redirect_to action: 'index', :controller => "settings"
  end
  
  private
  
  def get_instance_vars
    @resource = Resource.find(params[:id]) unless params[:id].blank?
  end
  
  def setting?
    !params[:setting_id].blank?
  end

  def product?
    !params[:product_id].blank?
  end

  def recipe?
    !params[:recipe_id].blank?
  end

  def default_url
    admin_settings_url if setting?
    admin_products_url if product?
    admin_recipes_url if recipe?
  end
end
