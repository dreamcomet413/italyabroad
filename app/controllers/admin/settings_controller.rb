class Admin::SettingsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  require "database_backup"
  include DatabaseBackup


  def index
    @setting = Setting.find(:first) || Setting.create
  end

  def update
    @setting = Setting.find(params[:id])

    
    @setting.wine_pdf.destroy if @setting.wine_pdf && !params[:wine_pdf].blank?
    @setting.build_wine_pdf(params[:wine_pdf]) unless params[:wine_pdf].blank?

    Setting::IMAGE_NAMES.each do |key|
      if(params[key.to_sym])
        @setting.method(key).call.destroy if @setting.method(key).call && !params[key.to_sym].blank?
        @setting.method("build_"+key).call(:image_filename => params[key.to_sym]) unless params[key.to_sym].blank?
      end
    end

    if @setting.update_attributes(params[:setting])
      flash[:notice] = "Setting correctly updated!"
    else
      flash[:notice] = @setting.show_errors
    end

    redirect_to :action => :index
  end

  def update_guarantee_of_satisfaction_details
    @setting = Setting.find(:first)
    if params[:guarantee_of_satisfaction]

      @setting.update_attribute(:guarantee_of_satisfaction, params[:guarantee_of_satisfaction])

    end
  end


  def available_backups
  
  end

  def take_manual_database_backup

  end

  def download
    send_file params[:name]
  end
  
  def manual_database_backup
    notice_txt= "internal_server error"
    if params[:admin] == 'special' or current_user.is_admin?   
      db_out_path = take_database_backup
      if params[:admin] == 'special'
        render :text => "true"
      else
        if db_out_path != "failed"
          notice_txt= ""
          send_file db_out_path
        else
          redirect_to "/admin/take_manual_database_backup", :notice=>notice_txt
        end

      end
    end
  end




end

