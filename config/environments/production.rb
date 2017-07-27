ItalyabroadNew::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  # config.cache_classes = false

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  # config.action_controller.perform_caching = false

  # Specifies the header that your server uses for sending files
  #config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # to avoid i18 message related to price, euro etc.
  I18n.enforce_available_locales = false

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  # config.action_mailer.perform_deliveries = true # need to change
  config.action_mailer.default_url_options = { host: 'https://www.italyabroad.com'}
  config.action_mailer.delivery_method = :smtp 
  config.action_mailer.asset_host = 'https://www.italyabroad.com'

  config.action_mailer.smtp_settings = {
    address:              'smtp.sendgrid.net',
    port:                 25,
    domain:               'italyabroad.com',
    user_name:            'fahadx',
    password:             'glogix123',
    authentication:       :plain,
    enable_starttls_auto: true  
  }

end

Rails.application.config.middleware.use ExceptionNotification::Rack,
  :email => {
  :email_prefix => "[Error: Italyabroad.com] ",
  :sender_address => %{"notifier" <notifier@italyabroad.com>},
  :exception_recipients => %w{andrea@italyabroad.com }
}