# Initial deployment.
#
# 1) Setup directory structure on remote VM.
#
#    $ cap dev deploy:setup
#
# 2) Manually copy files to $application/shared.
# 
#       - environment-specific configuration to config/environments.  
#       - certs to config/certs.
#
# 3) $ cap dev deploy:update
#
# Subsequent deployments:
#
#   # Stop robots, deploy code, start robots.
#   $ cap dev deploy
#
#   # Stop robots, deploy code.
#   $ cap dev deploy:update
#
#   # Start robots.
#   $ cap dev deploy:start

load 'deploy' if respond_to?(:namespace) # cap2 differentiator
require 'dlss/capistrano/robots'

set :application,     'assembly'
set :git_subdir,      "lyberteam/#{application}.git"
set :rvm_ruby_string, "1.8.7@#{application}"

task :dev do
  role :app, 'sul-lyberservices-dev.stanford.edu'
  set :deploy_env, 'development'
  set :rails_env,  'development'  # TEMPORARY: needed until lyberteam-gems-devel is fixed.
  set :bundle_without, []         # Deploy all gem groups on the dev VM.
end

task :testing do
  role :app, 'sul-lyberservices-test.stanford.edu'
  set :deploy_env, 'test'
  set :rails_env,  'test'  # TEMPORARY: see above
end

task :production do
  role :app, 'sul-lyberservices-prod.stanford.edu'
  set :deploy_env, 'production'
  set :rails_env,  'production' # TEMPORARY: see above
end

set :sunet_id,   Capistrano::CLI.ui.ask('SUNetID: ') { |q| q.default =  `whoami`.chomp }
set :rvm_type,   :system
set :user,       'lyberadmin' 
set :repository, "ssh://#{sunet_id}@corn.stanford.edu/afs/ir/dev/dlss/git/#{git_subdir}"
set :deploy_to,  "/home/#{user}/#{application}"
set :deploy_via, :copy
set :shared_config_certs_dir, true

after "deploy", "dlss:log_release"

# Robots run as background daemons. They are restarted at deploy time.
set :robots, %w(
  jp2-create 
  checksum-compute 
  exif-collect 
  accessioning-initiate
)
set :workflow, 'assemblyWF'

# after "deploy:symlink", "check_for_assembly_workspace"

desc "Check for /dor/assembly workspace"
task :check_for_assembly_workspace, :roles => [:app, :web] do
  Dir.mkdir '/dor/assembly' unless File.directory? '/dor/assembly'
end
