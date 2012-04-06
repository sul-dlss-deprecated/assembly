source :rubygems
source "http://sulair-rails-dev.stanford.edu"

gem "lyber-core", "2.0.4"
gem "dor-services", "3.3.4"
gem "checksum-tools"
gem "assembly-image"
gem "rest-client"

group :test do
  gem "rake"
  gem "rcov"
  gem "rspec", "~> 2.6"
  gem 'equivalent-xml'
end

group :development do
  if File.exists?(mygems = File.join(ENV['HOME'],'.gemfile'))
    instance_eval(File.read(mygems))
  end
  gem "ruby-debug"
  gem "capistrano", "2.9.0"
  gem "lyberteam-devel","0.5.3"
end

