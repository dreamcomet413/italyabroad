# Load the rails application
require File.expand_path('../application', __FILE__)
require "smtp_ssl"

# Initialize the rails application
ItalyabroadNew::Application.initialize!
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com",
:port => 587,
:authentication => :plain,
:user_name => "itserviceyouth@gmail.com",
:password => "harshad@456"
} 
