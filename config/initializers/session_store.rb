# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.

# ActionController::Base.session = {
#   :key         => '_italyabroad_session',
#   :secret      => 'e5cc8f8e8d2e41afa05daa9cf57f6826ba191246116e6c3c23e76c14da73b5fcf0fef6b9c51ec24fb1285608d3047b23c5193581daa3078c00a1918e50d8db31'
# }

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
