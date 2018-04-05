source 'https://rubygems.org'

gem 'assembly-image', '>=1.6.9'
gem 'assembly-objectfile', '>=1.6.6'
gem 'bluepill', '>=0.1.3'
gem 'dor-services', '~> 5.11', '>= 5.5.3'
gem 'druid-tools'
gem 'honeybadger'
gem 'lyber-core', '>=4.1.3'
gem 'mini_exiftool', '>= 1.6', '< 3'
gem 'nokogiri', '>=1.8.1'
gem 'pry-debugger', '~> 0.2.2', :platform => :ruby_19
gem 'pry-rescue'
gem 'pry-stack_explorer'
gem 'rake'
gem 'resque'
gem 'rest-client', '>=1.8'
gem 'robot-controller', '~> 2.0'
gem 'rubocop'
gem 'slop'

group :test do
  gem 'coveralls', require: false
  gem 'equivalent-xml'
  # Needed to support ruby 2.4+. No version since 1.3 has been released and this
  # appears like it might be unsupported.
  gem 'fakeweb', git: 'https://github.com/chrisk/fakeweb.git'
  gem 'rspec', '~> 3.4'
  gem 'simplecov'
end

group :deployment do
  gem 'capistrano', '~> 3'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'dlss-capistrano', '~> 3'
end

group :development do
  gem 'awesome_print'
end
