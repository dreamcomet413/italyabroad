Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'vLVmegFvgH1OqfHEi6kPYQ', 'dJHJdwafcZnGyvAUE5KWVJOrOLCSlNCcmcKCzpp3Qk', :access_token => '74390560-3bU2DSt3SM1ALA8kV97MjbZkJzYZHAvSiC2RZ7QhT'
  # provider :facebook, '899375176798298', '74361bf1694647233069a8c6195006d2', :scope => 'user_birthday, user_location, offline_access,email'#,manage_pages'
    provider :facebook, '59335954959', 'faa25c9b00239a2c16de842e6fd42c80',:client_options => {
     :site => 'https://graph.facebook.com/v2.0',
      :authorize_url => "https://www.facebook.com/v2.0/dialog/oauth"
    }#, :scope => 'user_birthday, user_location, offline_access,email'#,manage_pages'
end