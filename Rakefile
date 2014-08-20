require 'rake'
require 'rake/testtask'
require 'robot-controller/tasks'

Dir.glob('lib/tasks/*.rake').each { |r| import r }

desc 'Get application version'
task :app_version do
  puts File.read(File.expand_path('../VERSION', __FILE__)).match('[\w\.]+')[0]
end

require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Load complete environment into rake process'
task :environment do
  require_relative 'config/boot'
end