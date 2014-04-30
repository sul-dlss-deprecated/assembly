server 'sul-lyberservices-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
# server 'sul-robots1-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
# server 'sul-robots2-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}

Capistrano::OneTimeKey.generate_one_time_key!

set :branch, 'assembly-aalsum'
set :deploy_environment, 'development'
