namespace :deploy do

  desc 'Restart application'
  task :restart do
    puts 'skipping'
  end

  after :publishing, :restart

end

server 'sul-lyberservices-prod.stanford.edu', user: 'lyberadmin', roles: %w{web app db}

Capistrano::OneTimeKey.generate_one_time_key!

set :branch, 'master'
set :deploy_environment, 'lyberservices'
set :default_env, { :robot_environment => 'production' }