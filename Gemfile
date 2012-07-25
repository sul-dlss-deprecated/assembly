source :rubygems
source "http://sulair-rails-dev.stanford.edu"

gem "lyber-core"
gem "assembly-objectfile", ">= 1.2.5"
gem "assembly-image", ">= 1.3.0"
gem "assembly-utils", ">= 1.0.5"
gem "rest-client"
gem "rake"
gem "druid-tools"
gem "dor-services", "~> 3.8.0"

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
  gem "lyberteam-devel", "<= 0.8.0"  # we need to stay on older versions for now until we can fix the deployment capistrano issues, 7/25/2012, Peter Mangiafico
  gem "lyberteam-capistrano-devel", "<= 0.9.0"
end
