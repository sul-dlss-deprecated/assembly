server 'sul-robots1-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots2-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
# server 'sul-robots3-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
# server 'sul-robots4-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
# server 'sul-robots5-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}

Capistrano::OneTimeKey.generate_one_time_key!

set :deploy_environment, 'development'
set :whenever_environment, fetch(:deploy_environment)
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:deploy_environment)}" }
set :default_env, { :robot_environment => fetch(:deploy_environment) }
