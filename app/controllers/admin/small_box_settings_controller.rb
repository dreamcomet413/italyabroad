class Admin::SmallBoxSettingsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
  	@small_box_setting = SmallBoxSetting.find(:first) || SmallBoxSetting.create 
  end
  def update
  	SmallBoxSetting.update(params[:small_box_settings].keys, params[:small_box_settings].values)
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