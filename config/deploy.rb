#require 'capistrano/ext/multistage'
set :application, "italyabroad"
set :deploy_to, "/home/italy/italyabroad"



#set :user, "italy"
#set :scm_passphrase, "italyabroad1"
set :user, "italy"
set :password, "italyabroad1"
set :domain, "89.145.121.178"
server domain, :app, :web
role :db, domain, :primary => true

  
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#set :stages, ["staging", "production"]
#set :default_stage, "production"
set :keep_releases,       5
default_run_options[:pty] = true
set :use_sudo, true


set :scm, :git
set :repository, "git@github.com:italyabroad/italyabroad.git"
#set :repository, "https://github.com/italyabroad/italyabroad.git"
#set :git_enable_submodules, 1
#set :branch, 'master'

#set :scm_username, 'yuvasoft'
#set :scm_password, 'yuva_hitesh1988'
#ssh_options[:forward_agent] = true
#ssh_options[:auth_methods] = "publickey"
#ssh_options[:keys] = ["/home/italy/.ssh/authorized_keys"]

#role :web, "italyabroad.com"                          # Your HTTP server, Apache/etc
#role :app, "italyabroad.com"                          # This may be the same as your `Web` server
#role :db,  "italyabroad.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
#set :deploy_via, :remote_cache
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
#namespace :deploy do
 # task :start do ; end
 # task :stop do ; end
  # task :restart, :roles => :app, :except => { :no_release => true } do
  #  run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  #end
#end
namespace :deploy do

  desc "Restarting httpd "
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo /sbin/service httpd stop"
    run "sudo /sbin/service httpd start"
  end

  task :symlinks do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
