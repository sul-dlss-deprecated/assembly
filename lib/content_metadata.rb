require 'assembly-objectfile'

module Dor::Assembly
  module ContentMetadata

    attr_accessor(
      :cm,
      :cm_file_name,
      :stub_cm_file_name,
      :cm_handle,
      :druid,
      :root_dir
    )

    def cm_file_name
      @cm_file_name ||= metadata_file(Dor::Config.assembly.cm_file_name)
    end

    def stub_cm_file_name
      @stub_cm_file_name ||= metadata_file(Dor::Config.assembly.stub_cm_file_name)
    end
    
    def content_metadata_exists?
      # indicate if a contentMetadata file exists
      File.exists?(cm_file_name)  
    end

    def stub_content_metadata_exists?
      # indicate if a stub contentMetadata file exists
      File.exists?(stub_cm_file_name)
    end
    
    def load_content_metadata
      # Loads content metadata XML into a Nokogiri document.
      raise "Content metadata file #{Dor::Config.assembly.cm_file_name} not found for #{druid.id} in any of the root directories: #{@root_dir.join(',')}" unless File.exists? cm_file_name
      @cm = Nokogiri.XML(File.open cm_file_name) { |conf| conf.default_xml.noblanks }
    end

    def persist_content_metadata
      # Writes content metadata XML to the content metadata file or
      # to @cm_handle (the latter is used for testing purposes).
      xml = @cm.to_xml
      if @cm_handle
        @cm_handle.puts xml
      else
        File.open(cm_file_name, 'w') { |f| f.puts xml }
      end
    end

    def new_node_in_cm(node_name)
      # Returns a new node with the supplied name (with the GC lifecycle of
      # the content metadata document).
      Nokogiri::XML::Node.new node_name, @cm
    end

    def file_nodes(resource_type='')
      # Returns all Nokogiri <file> nodes from content metadata, optionally restricted to specific resource content types if specified
      xpath_query = "//resource"
      xpath_query += "[@type='#{resource_type}']" unless resource_type==''
      xpath_query += "/file"
      @cm.xpath xpath_query
    end

    def fnode_tuples(resource_type='')
      # Returns a list of filenode pairs (file node and associated ObjectFile object), optionally restricted to specific resource content types if specified
      file_nodes(resource_type).map { |fn| [ fn, Assembly::ObjectFile.new(content_file(fn['id'])) ] }
    end
        
    def create_content_metadata
      # uses the assembly-objectfile gem to create content metadata using the stub contentMetadata provided
      # TODO load the stub content metadata, parse and use gem to create
      xml='<contentMetadata/>'
      @cm = Nokogiri.XML(xml)
    end

  end
end

