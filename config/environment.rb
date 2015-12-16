# Load the rails application
require File.expand_path('../application', __FILE__)
require "smtp_ssl"

# Initialize the rails application
ItalyabroadNew::Application.initialize!
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

ActionMailer::Base.smtp_settings = {
:address => "smtp.aruba.it",
:port => 465,
:authentication => :plain,
:user_name => "info@italyabroad.com",
:password => "infoinfo"
}
