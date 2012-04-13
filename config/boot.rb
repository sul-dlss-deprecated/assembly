require 'rubygems'
require 'bundler/setup'
require 'active_support/core_ext'

# Environment and robot root directory.
environment = ENV['ROBOT_ENVIRONMENT'] ||= 'development'
ROBOT_ROOT  = File.expand_path(File.dirname(__FILE__) + "/..")

# Add subdirs to the load path.
%w(lib robots).each do |d|
  $LOAD_PATH.unshift File.join(ROBOT_ROOT, d)
end

# Set up the robot logger.
require 'logger'
ROBOT_LOG       = Logger.new(File.join(ROBOT_ROOT, "log/#{environment}.log"))
ROBOT_LOG.level = Logger::SEV_LABEL.index(ENV['ROBOT_LOG_LEVEL']) || Logger::INFO

# Override the Solrizer logger before it loads and pollutes STDERR.
begin
  require 'solrizer'
  Solrizer.logger = ROBOT_LOG
rescue LoadError, NameError, NoMethodError
end

# Require general DLSS infrastructure.
# Some of these requires must occur before we load the environment file. 
require 'dor-services'
require 'lyber_core'
require 'checksum-tools'

# Define modules, with autoload behavior, needed by the robot framework.
def camel_case(s)
  s.split(/_/).map { |part| part.capitalize }.join('')
end

workflow_dirs = Dir["#{ROBOT_ROOT}/robots/*"].select { |f| File.directory?(f) }
workflow_dirs.each do |wfdir|
  # For each workflow (eg, assembly), create a module (Assembly).
  module_name = camel_case File.basename(wfdir)
  mod         = Module.new

  robot_files = Dir["#{wfdir}/*.rb"]
  robot_files.each do |rf|
    # For each robot step in that workflow (eg, checksum.rb), 
    # set up an autoload: eg, Assembly.autoload(:Checksum, 'checksum').
    robot_name = camel_case File.basename(rf, '.rb')
    mod.autoload(robot_name.to_sym, rf)
  end

  Object.const_set(module_name.to_sym, mod)
end

# Require the project and environment.
# These requires need to come after the autoload code; otherwise, you
# get a warning about an already-initialized constant.
env_file = File.expand_path(File.dirname(__FILE__) + "/./environments/#{environment}")
require env_file

require 'assembly'
require 'assembly-image'
