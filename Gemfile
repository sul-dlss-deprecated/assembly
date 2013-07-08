source 'https://rubygems.org'
source 'http://sul-gems.stanford.edu'

gem "lyber-core"
gem "assembly-objectfile", ">= 1.4.9"
gem "assembly-image", ">= 1.4.0"
gem "assembly-utils", ">= 1.2.1"
gem "rest-client"
gem "rake"
gem "druid-tools"
gem "mini_exiftool", "~> 1.6"
gem "dor-services", ">= 3.8.0"
gem "nokogiri", "~> 1.5.10" # 1.6.x requires ruby 1.9
gem "activesupport", "~> 3" # 4.0 requires ruby 1.9.3
gem "actionpack", "~> 3" # 4.0 requires ruby 1.9.3
gem "actionmailer", "~> 3" # 4.0 requires ruby 1.9.3

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
