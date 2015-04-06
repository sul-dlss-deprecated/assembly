namespace :deploy do

  desc 'Restart application'
  task :restart do
    # nada
  end

  after :publishing, :restart

end

server 'sul-lyberservices-prod.stanford.edu', user: 'lyberadmin', roles: %w{web app db}

Capistrano::OneTimeKey.generate_one_time_key!

set :branch, 'master'
set :deploy_environment, 'production'
set :default_env, { :robot_environment => fetch(:deploy_environment) }