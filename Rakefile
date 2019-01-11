require 'rake'
require 'rake/testtask'
require 'resque/tasks'
require 'robot-controller/tasks'
require 'rubocop/rake_task'
RuboCop::RakeTask.new

Dir.glob('lib/tasks/*.rake').each { |r| import r }

desc 'Get application version'
task :app_version do
  puts File.read(File.expand_path('VERSION', __dir__)).match('[\w\.]+')[0]
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task default: %i[spec rubocop]

task :environment do
  require_relative 'config/boot'
end
