class Admin::ResourcesController < ApplicationController
  before_filter :admin_login_required
  before_filter :get_instance_vars
  
  def destroy
    @resource.destroy
    redirect_to default_url
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
    return admin_settings_url unless params[:setting_id].blank?
    return admin_products_url unless params[:product_id].blank?
    return admin_recipes_url unless params[:recipe_id].blank?
    return admin_producers_url unless params[:producer_id].blank?
    return admin_regions_url unless params[:region_id].blank?
    return admin_grapes_url unless params[:grape_id].blank?
    return news_letter_images_url(NewsLetter.find(params[:news_letter_id])) unless params[:news_letter_id].blank?
    return siteadmin_url
  end
end
