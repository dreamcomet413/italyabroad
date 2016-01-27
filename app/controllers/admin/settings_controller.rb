class Admin::SettingsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  require "database_backup"
  include DatabaseBackup

  before_filter :authenticate, :only => [:available_backups, :restore, :take_backup_now, :download]

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'db_admin' && password == 'andrea321!'
    end
  end


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

  def take_backup_now

    Thread.new do 
      Setting.take_database_backup
    end

    redirect_to available_backups_admin_settings_path
  end

  def download
    send_file params[:name]
  end
  

  def restore
    if config = YAML::load(ERB.new(IO.read(Rails.root.to_s + "/config/database.yml")).result)[Rails.env]      
      tempdb_directory = File.join(Rails.root,'/tempdb')
      if !File.exists? tempdb_directory
        Dir.mkdir tempdb_directory
      end
      
      file_path = File.join(tempdb_directory,"temp.sql")
      file_size = File.size("#{tempdb_directory}")
      if file_size > 0
      system "gunzip -c #{params[:name]} > 'tempdb/temp.sql'"
      system "mysql -u #{config['username']} -p'#{config['password']}' #{config['database']} < tempdb/temp.sql"
      # schedule_backup
      else
        system "rm #{file_path}"
      end

    else
      render :text => "No database is configured for the environment '#{Rails.env}'"
    end
    redirect_to available_backups_admin_settings_path
  end




end

