source :rubygems
source "http://sulair-rails-dev.stanford.edu"

gem "lyber-core"
gem "assembly-objectfile", "~> 1.1.2"
gem "assembly-image", "~> 1.2.1"
gem "rest-client"
gem "rake"

group :test do
  gem "rcov"
  gem "rspec", "~> 2.6"
  gem 'equivalent-xml'
end

group :development do
  if File.exists?(mygems = File.join(ENV['HOME'],'.gemfile'))
    instance_eval(File.read(mygems))
  end
  gem "ruby-debug"
  gem "capistrano"
  gem "lyberteam-devel"
end
