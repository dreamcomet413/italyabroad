require 'rubygems'
module DatabaseBackup
    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
  def take_database_backup
    # encoding: utf-8
    #require 'sanitize'
    #require 'iconv'
    if config = YAML::load(ERB.new(IO.read(Rails.root.to_s + "/config/database.yml")).result)[Rails.env]
      begin
        backup_directory = File.join(Rails.root,'/backups')
        if !File.exists? backup_directory
          Dir.mkdir backup_directory
        end
        db_out_path = File.join(backup_directory, "Database-#{Time.now.strftime("%B-%d-%Y_%H:%M:%S")}.sql.gz")
        system "mysqldump -u #{config['username']} -p'#{config['password']}' #{config['database']} | gzip > #{db_out_path}"
        # system "mysqldump -u #{config['username']} -p#{config['password']} #{config['database']} | gzip > /Rails/backups/database_`date '+%m-%d-%Y_%H_%M_%S'`.sql.gz"
        # system "mysqldump -u #{config['username']} -p#{config['password']} #{config['database']} | gzip > /Rails/backups/database_#{Time.now.strftime("%m-%d-%Y_%H_%M_%S")}.sql.gz"
        #system "cp #{db_out_path} #{RAILS_ROOT}/backups/database_#{Time.now.strftime("%m-%d-%Y_%H_%M_%S")}.sql.gz"

        count_backups = Dir.glob(File.join(backup_directory,'/*')).select{|file| File.file?(file)}.count
        while count_backups > 30
          oldest_backup = Dir.glob(File.join(backup_directory,'/*')).select{|f| File.file? f }.sort_by{|f| File.mtime f }.first
          File.delete oldest_backup
          count_backups = Dir.glob(File.join(backup_directory,'/*')).select{|file| File.file?(file)}.count
        end
        # while AmazonBackup.all.length >= BackupConfiguration.last.maximum_number_of_amazon_backups
        #   AmazonBackup.first.destroy
        # end
        # @amazon_backup = AmazonBackup.new
        # @amazon_backup.backup = File.open(db_out_path)
        # @amazon_backup.save

        # @email_address=EmailAddress.find_by_id(1)
        # @email = 'info@italyabroad.com' #@email_address.success_backup_email_address if @email_address
        # if @email != nil and @email != ''
        #   ConfigurationNotifier.backup_success(@email,db_out_path).deliver
        # end
        db_out_path
      rescue Exception => e
        #users = User.where(:is_admin => true)
        #users.each do|user|
        # @email_address=EmailAddress.find_by_id(1)
        # @email = 'info@italyabroad.com'#@email_address.failure_backup_email_address if @email_address
        # if @email != nil and @email != ''
        #   ConfigurationNotifier.backup_failure(@email, e,db_out_path).deliver
        # end
        "failed"
      end
    else
      render :text => "No database is configured for the environment '#{Rails.env}'"
    end
  end
  
  def upload_database_backup(file)    
    begin
      backup_directory = File.join(Rails.root,'/backups')
      if !File.exists? backup_directory
        Dir.mkdir backup_directory
      end
      # db_out_path = File.join(backup_directory, "#{name}")  
      
      # contents = file.read
      contents = file.open.read
      db_out_path = "#{backup_directory}/#{file.original_filename}"
      # contents = ActionView::Base.full_sanitizer.sanitize(contents)
      
      File.open("#{backup_directory}/#{file.original_filename}","w") {|f| f.write(contents) }
      count_backups = Dir.glob(File.join(backup_directory,'/*')).select{|file| File.file?(file)}.count
      while count_backups > BackupConfiguration.last.number_of_backups
        oldest_backup = Dir.glob(File.join(backup_directory,'/*')).select{|f| File.file? f }.sort_by{|f| File.mtime f }.first
        File.delete oldest_backup
        count_backups = Dir.glob(File.join(backup_directory,'/*')).select{|file| File.file?(file)}.count
      end
      
      # while AmazonBackup.all.length >= BackupConfiguration.last.maximum_number_of_amazon_backups
      #   AmazonBackup.first.destroy
      # end
      # @amazon_backup = AmazonBackup.new
      # @amazon_backup.backup = File.open(db_out_path)
      # @amazon_backup.save

      @email_address=EmailAddress.find_by_id(1)
      @email = @email_address.success_backup_email_address if @email_address
      if @email != nil and @email != ''
        ConfigurationNotifier.backup_success(@email,db_out_path).deliver
      end
      db_out_path
    rescue Exception => e      
      @email_address=EmailAddress.find_by_id(1)
      @email = @email_address.failure_backup_email_address if @email_address
      if @email != nil and @email != ''
        ConfigurationNotifier.backup_failure(@email, e,db_out_path).deliver
      end
    end    
  end
end
