# config valid only for current version of Capistrano
#lock '3.6.1'
#
#set :application, 'my_app_name'
#set :repo_url, 'git@example.com:me/my_repo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
#require 'bundler/capistrano'
#$:.unshift("#{ENV["HOME"]}/.rvm/lib")
#require "rvm/capistrano"
# Default value for keep_releases is 5
# set :keep_releases, 5
lock '3.6.1'
#require 'rvm/capistrano'
#require 'bundler/capistrano'
set :stage, :production
set :application, 'contactbook'
set :deploy_user, 'deploy'
set :repo_url, 'git@github.com:sureshchipurupalli/contactbook.git' # Edit this to match your repository
set :branch, :master
set :keep_releases, 2
set :scm, :git
set :scm_username, 'sureshchipurupalli'
set :deploy_to, '/home/deploy/contactbook'
set :pty, false
#default_run_options[:pty] = true
set :use_sudo, true
set :log_level, :debug
set :log_level, :debug
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :user, "auto"

set :git_shallow_clone, 1
set :scm_verbose, true
set :migration_role, :db
set :migration_servers, -> { primary(fetch(:migration_role)) }
set :conditionally_migrate, true
set :rvm_ruby_version,'default' # Edit this if you are using MRI Ruby
#set :rvm_ruby_version, 'ruby-2.2.1p85'
set :assets_roles, [ :web]
set :assets_prefix, 'prepackaged-assets'
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}
set :keep_assets, 2
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false
set :rails_env, "production"
set :deploy_via, :remote_cache
set :copy_compression, :bz2
before  'deploy:assets:precompile', 'deploy:migrate'
set :ssh_options, { :forward_agent => true }
set :ssh_options, { :auth_methods => "publickey"}
set :ssh_options, {:keys => ["/home/media3/Desktop/new-server-key.pem"]}
fetch(:default_env).merge!(rails_env: :production)
#after 'deploy:update_code', 'deploy:symlink_db'
namespace :deploy do
  after :restart, :clear_cache do
    on roles( :web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

Rake::Task[:production].invoke
