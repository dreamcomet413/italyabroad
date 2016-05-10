class Admin::SmallBoxSettingsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
  	@small_box_settings = SmallBoxSetting.all
  end
  def update
  	@small_box = SmallBoxSetting.find(params[:small_box_setting])
  	# if(params[key.to_sym])
      # @setting.method(key).call.destroy if @setting.method(key).call && !params[key.to_sym].blank?
      # @setting.method("build_"+key).call(:image_filename => params[key.to_sym]) unless params[key.to_sym].blank?
    # end 
    if @small_box.update_attributes(params[:setting])
      flash[:notice] = "Setting correctly updated!"
    else
      flash[:notice] = @small_box.show_errors
    end
  end
  def destroy
    small_box = SmallBoxSetting.find(params[:id])

    if small_box.destroy
      flash[:notice] = "Image is deleted!"
    end

    respond_to do |format|
      format.html { redirect_to :action => :index }
    end
  end

end