source 'https://rubygems.org'

gem "lyber-core", "~> 4.0", ">= 4.1.0"
gem "assembly-objectfile", ">=1.6.6"
gem "assembly-image", ">=1.6.9"
gem 'activesupport', '< 5'
gem "rest-client", '>=1.8'
gem "rake"
gem "druid-tools"
gem "mini_exiftool", ">= 1.6", "< 3"
gem "dor-services", "~> 5.11", ">= 5.5.3"
gem "nokogiri"
gem 'resque'
gem "pry-debugger", '~> 0.2.2', :platform => :ruby_19
gem 'pry-rescue'
gem 'pry-stack_explorer'
gem 'robot-controller', '~> 2.0'
gem 'slop'
gem 'bluepill', git: 'https://github.com/bluepill-rb/bluepill.git'

group :test do
  gem 'equivalent-xml'
  gem 'yard'
  gem 'rspec', '~> 3.4'
  gem 'coveralls', require: false
  gem 'simplecov'
  gem 'fakeweb'
end

group :development, :test do
  gem 'rubocop'
end

group :deployment do
  gem "capistrano", '~> 3'
  gem 'capistrano-bundler'
  gem "dlss-capistrano", '~> 3'
  gem 'capistrano-rvm'
end

group :development do
  gem 'awesome_print'
end
