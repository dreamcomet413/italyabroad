server "italyabroad.com", :app, :web, :db, :primary => true
set :deploy_to, "/srv/italyabroad"
set :rake, 'bundle exec rake'

#set :location, "italyabroad.com"
#set :rails_env, 'production'

#set :branch, 'master'

#role :app, '89.145.121.178'
#role :web, '89.145.121.178'
#role :db, '89.145.121.178', :primary => true
