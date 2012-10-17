environment = (ENV['ROBOT_ENVIRONMENT'] ||= 'development')
bootfile    = File.expand_path(File.dirname(__FILE__) + '/../config/boot')

require bootfile
require 'tempfile'  
require 'equivalent-xml'  

tmp_output_dir = File.join(ROBOT_ROOT, 'tmp')
FileUtils.mkdir_p tmp_output_dir

TMP_ROOT_DIR = "tmp/test_input"

# override for testing
Dor::Config.assembly.root_dir=['spec/test_input','spec/test_input2']

include Assembly  
def noko_doc(x)
  # Returns Nokogiri XML Document, with config to ignore blanks.
  Nokogiri.XML(x) { |conf| conf.default_xml.noblanks }
end

def get_filenames(item)
  item.file_nodes.map { |fn| item.content_file fn['id'] }
end

def count_file_types(files,extension)
  files.reject {|file| File.extname(file) != extension}.size
end

def clone_test_input(destination)
  # Use rsync to create a copy of the test_input directory that we can modify.
  source = 'spec/test_input'
  system "rsync -rqOlt --delete #{source}/ #{destination}/"
end
