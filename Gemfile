source :rubygems
source "http://sulair-rails-dev.stanford.edu"

gem "lyber-core"
gem "assembly-objectfile", ">= 1.2.5"
gem "assembly-image", ">= 1.3.0"
gem "assembly-utils", ">= 1.0.10"
gem "rest-client"
gem "rake"
gem "druid-tools"
gem "dor-services", ">= 3.8.0"

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
	gem 'lyberteam-devel', '>= 1.0.1'
	gem 'lyberteam-capistrano-devel', '>= 1.1.0'
end
