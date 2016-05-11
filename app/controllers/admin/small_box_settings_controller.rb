class Admin::SmallBoxSettingsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
  	@small_box_setting = SmallBoxSetting.find(:first) || SmallBoxSetting.create 
  end
  def update
  	# @small_box = SmallBoxSetting.find(params[:id])
  	# SmallBoxSetting.all.each do |sb|
   #    @small_box_setting.method("build_"+sb).call(:image_filename => params[sb.to_sym]) unless params[sb.to_sym].blank?
   #  end
   #  if @small_box.update_attributes(params[:setting])
   #    flash[:notice] = "Setting correctly updated!"
   #  else
   #    flash[:notice] = @small_box.show_errors
   #  end
    
    byebug    
    SmallBoxSetting.update(params[:small_box_settings].keys, params[:small_box_settings].values)
      
    
    logger.info('=====================================================================================')
    logger.info(params[:small_box_setting])
    logger.info('=====================================================================================')
    redirect_to action: :index
  end
  def destroy
    small_box = SmallBoxSetting.find(params[:id])

    if small_box.image.destroy
      flash[:notice] = "Image is deleted!"
    end

    respond_to do |format|
      format.html { redirect_to :action => :index }
    end
  end

end