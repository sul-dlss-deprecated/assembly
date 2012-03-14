environment = ENV['ROBOT_ENVIRONMENT'] ||= 'development'
bootfile    = File.expand_path(File.dirname(__FILE__) + '/../config/boot')

require bootfile
require 'tempfile'  
require 'equivalent-xml'  

tmp_output_dir = File.join(ROBOT_ROOT, 'tmp')
FileUtils.mkdir_p tmp_output_dir
  
def noko_doc(x)
  # Returns Nokogiri XML Document, with config to ignore blanks.
  Nokogiri.XML(x) { |conf| conf.default_xml.noblanks }
end

def clone_test_input(destination)
  # Use rsync to create a copy of the test_input directory that we can modify.
  source = Dor::Config.assembly.root_dir
  system "rsync -rqOlt --delete #{source}/ #{destination}/"
end
