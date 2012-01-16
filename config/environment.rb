# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'pdfkit'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"

  # config.gem "aws-s3", :lib => "aws/s3"
  # config.gem "rmagick"
  # config.gem "xml-simple", :version => '1.0.12'
  # config.gem " mime-types"
  config.gem 'prawn'
  config.gem "activemerchant", :version => ">= 1.5.1", :lib => "active_merchant"
  config.gem 'fleximage'
  config.gem 'will_paginate', :version => '>= 2.3.12'
  config.gem "RedCloth"
  config.gem "pdfkit"
  config.middleware.use "PDFKit::Middleware"
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'
  config.middleware.use PDFKit::Middleware

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # This line added by Sujith since we believe httponly is a problem while redirecting to HTTPS in checkout/payment page
  config.action_controller.session = { :httponly => false }

end

=begin
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => "587",
  :domain => "gmail.com",
  :authentication => :plain,
  :user_name => "mail@ejubel.com",
  :password => "server123"
}
=end

=begin
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => "587",
  :domain => "gmail.com",
  :authentication => :plain,
  :user_name => "surendran.nair.suvas@gmail.com",
  :password => "123456go"
}
=end
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "smtp.italyabroad.com",
   :port => 25,
   :domain => "www.italyabroad.com",
   :authentication => :login,
   :user_name => "info@italyabroad.com",
   :password => "infoinfo"
}

=begin
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "smtp.italyabroad.com",
   :port => 25,
   :domain => "www.italyabroad.com",
   :authentication => :login,
   :user_name => "info@italyabroad.com",
   :password => "info"
}

=end
=begin
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "smtp.italyabroad.com",
   :port => 25,
   :domain => "www.italyabroad.com",
   :authentication => :login,
   :user_name => "info@italyabroad.com",
   :password => "info"
}
=end


require "custom_country_select"

