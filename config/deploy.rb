#require 'capistrano/ext/multistage'
require 'rvm/capistrano'
set :application, "italyabroad"
set :deploy_to, "/home/italy/italyabroad"
#set :deploy_to, "/srv/italyabroad"

set :user, "italy"
#set :scm_passphrase, "italyabroad1"
#set :user, "root"
#set :password, "italyabroad1"
set :domain, "89.145.121.178"
#set :domain, "192.241.165.181"
#set :domain, "104.131.110.105"
server domain, :app, :web
role :db, domain, :primary => true
set :rvm_ruby_string, 'ruby-2.0.0-p353'
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
#set :rvm_type, :system

  
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#set :stages, ["staging", "production"]
#set :default_stage, "production"
set :keep_releases,       5
default_run_options[:pty] = true
#set :use_sudo, true

#before 'deploy:setup', 'rvm:install_rvm'

after "deploy:update_code" do
  run "ls -al #{fetch(:release_path)} && which ruby"
  bundle_dir = File.join(fetch(:shared_path), 'bundle')
  args = ["--path #{bundle_dir}"]
  args << "--without development"
  run "cd #{fetch(:release_path)} && bundle install #{args.join(' ')}"
end

set :scm, :git
set :repository, "git@github.com:italyabroad/italyabroad.git"
#set :repository, "https://github.com/italyabroad/italyabroad.git"
#set :repository, "ssh://git@bitbucket.org/neerajkumar/italyabroad_new.git"
set :rake, 'bundle exec rake'
#set :repository, "https://github.com/italyabroad/italyabroad.git"
#set :git_enable_submodules, 1
set :branch, 'master'

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
after "deploy:restart", "deploy:cleanup"
after "deploy:restart", "deploy:start_juggernaut"
before "deploy:restart", "deploy:tmp_symlinks"
#set :deploy_via, :remote_cache
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
 task :start do ; end
 task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :deploy do

  #desc "Restarting httpd "
  #task :restart, :roles => :app, :except => { :no_release => true } do
  #  run "/sbin/service httpd stop"
  #  run "/sbin/service httpd start"
  #end

  task :create_symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
    run "ln -nfs #{shared_path}/public/uploads #{current_path}/public"
    run "cd #{current_path}/public && rm -rf resources && ln -nfs #{shared_path}/public/resources #{current_path}/public"
    #run "cd #{current_path} && chmod -R 777 tmp/"
  end

  task :tmp_symlinks do
    run "cd #{current_path} && rm -rf tmp && ln -s #{shared_path}/tmp tmp"
  end

  desc "start the juggernaut server"
  task :start_juggernaut do
    run "cd #{current_path} && nohup /etc/init.d/juggernaut restart &"
  end

  desc "Recreate symlink"
  task :resymlink, :roles => :app do
    run "rm -f #{current_path} && ln -s #{release_path} #{current_path}"
  end
end
after "deploy", "deploy:create_symlink"
before "deploy:create_symlink", "deploy:resymlink"
