environment = ENV['ROBOT_ENVIRONMENT'] ||= 'development'
bootfile    = File.expand_path(File.dirname(__FILE__) + '/../config/boot')

require bootfile
require 'tempfile'  
require 'equivalent-xml'  
  
def noko_doc(x)
  Nokogiri.XML(x) { |conf| conf.default_xml.noblanks }
end
