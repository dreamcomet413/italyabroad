Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'vLVmegFvgH1OqfHEi6kPYQ', 'dJHJdwafcZnGyvAUE5KWVJOrOLCSlNCcmcKCzpp3Qk', :access_token => '74390560-3bU2DSt3SM1ALA8kV97MjbZkJzYZHAvSiC2RZ7QhT'
  provider :facebook, '631519600219374', '4a4324e295714c2026366374504f5ff4', {:client_options => {:ssl => {:ca_file => "/etc/pki/tls/certs/ca-bundle.crt"}}, :scope => 'publish_stream,offline_access,email,read_stream,manage_pages'}
end