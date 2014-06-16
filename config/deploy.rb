# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

#requrire bundler's capistrano tasks to automate gem installation during deployment
require "bundler/capistrano"

#itegration for capistrano with rvm
$:.unshift("./vendor/lib")     # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ruby-1.9.3'   # Or whatever env you want it to run in.
#end integration

set :user, 'alien8web'
set :application, "guylaine"
set :scm, :git
set :repository, "git@github.com:sohara/Guylaine.git"
set :scm_verbose, true
set :git_shallow_clone, 1
set :keep_releases, 4
default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :ssh_options, { :forward_agent => true }
set :use_sudo, false

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

role :web, "107.170.131.58"
role :app, "107.170.131.58"
role :db,  "107.170.131.58", :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "/opt/app" # defaults to "/u/apps/#{application}"
set :user, "web"            # defaults to the currently logged in user
# set :scm, :darcs               # defaults to :subversion
# set :svn, "/path/to/svn"       # defaults to searching the PATH
# set :darcs, "/path/to/darcs"   # defaults to searching the PATH
# set :cvs, "/path/to/cvs"       # defaults to searching the PATH
# set :gateway, "gate.host.com"  # default to no gateway

# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)

desc <<DESC
An imaginary backup task. (Execute the 'show_tasks' task to display all
available tasks.)
DESC
task :backup, :roles => :db, :only => { :primary => true } do
  # the on_rollback handler is only executed if this task is executed within
  # a transaction (see below), AND it or a subsequent task fails.
  on_rollback { delete "/tmp/dump.sql" }

  run "mysqldump -u theuser -p thedatabase > /tmp/dump.sql" do |ch, stream, out|
    ch.send_data "thepassword\n" if out =~ /^Enter password:/
  end
end

desc "Create the symlink to the database.yml in /shared"
task :db_sym_link, :roles => :app do
    run "ln -s #{deploy_to}/shared/database.yml #{current_release}/config/database.yml"
end


desc "Create the symlink to the image dirs for uploaded images"
task :image_sym_link, :roles => :app do
  run "ln -s #{deploy_to}/shared/uploaded #{current_release}/public/uploaded"
end

desc <<-DESC
A macro-task that updates the code, fixes the symlink, and restarts the
application servers.
DESC
deploy.task :default do
  transaction do
    update_code
    image_sym_link
    db_sym_link
    symlink
  end
  cleanup
  restart
end

# You can use "transaction" to indicate that if any of the tasks within it fail,
# all should be rolled back (for each task that specifies an on_rollback
# handler).

desc "A task demonstrating the use of transactions."
task :long_deploy do
  transaction do
    update_code
    disable_web
    symlink
    migrate
  end

  restart
  enable_web
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
## Tasks to restart passenger standalone
# namespace :deploy do
#   desc "Start passenger standalone"
#   task :start, :roles => :app, :except => { :no_release => true } do
#     run "cd #{current_path} && bundle exec passenger start -a 127.0.0.1 -p 3001 --daemonize --environment production"
#   end
#   desc "Stop passenger standalone on the server"
#   task :stop, :roles => :app, :except => { :no_release => true } do
#     run "cd #{current_path} && bundle exec passenger stop --port 3001"
#   end
#   desc "Retart passenger standalone"
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
#   end
# end
