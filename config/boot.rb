require 'rubygems'
require 'bundler/setup'

# Environment and robot root directory.
environment = ENV['ROBOT_ENVIRONMENT'] ||= 'development'
ROBOT_ROOT  = File.expand_path(File.dirname(__FILE__) + '/..')

# Add subdirs to the load path.
%w[lib robots].each do |d|
  $LOAD_PATH.unshift File.join(ROBOT_ROOT, d)
end

require 'honeybadger'

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

require 'assembly/accessioning_initiate'
require 'assembly/checksum_compute'
require 'assembly/exif_collect'
require 'assembly/jp2_create'
require 'assembly/content_metadata_create'
require 'assembly'

# Require the project and environment.
# These requires need to come after the autoload code; otherwise, you
# get a warning about an already-initialized constant.
env_file = File.expand_path(File.dirname(__FILE__) + "/./environments/#{environment}")
require env_file
require 'assembly-image'

require 'resque'
REDIS_URL ||= "localhost:6379/resque:#{ENV['ROBOT_ENVIRONMENT']}".freeze
Resque.redis = REDIS_URL

require 'robot-controller'
