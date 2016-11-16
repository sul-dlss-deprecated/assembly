require 'assembly-objectfile'
require 'stub_content_metadata_parser'

module Dor::Assembly
  module ContentMetadata

    include StubContentMetadataParser

    attr_accessor(
      :cm,
      :stub_cm,
      :cm_file_name,
      :stub_cm_file_name,
      :cm_handle,
      :druid,
      :root_dir
    )

    # return the location to store the contentMetadata.xml file (could be in either the new or old location)
    def cm_file_name
      @cm_file_name ||= (folder_style == :new ? path_to_metadata_file(Dor::Config.assembly.cm_file_name) : old_path_to_file(Dor::Config.assembly.cm_file_name))
    end

    # return the location to read the stubContentMetadata.xml file from (could be in either the new or old location)
    def stub_cm_file_name
      @stub_cm_file_name ||= (folder_style == :new ? path_to_metadata_file(Dor::Config.assembly.stub_cm_file_name) : old_path_to_file(Dor::Config.assembly.stub_cm_file_name))
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
      path_to_object
      raise "Content metadata file #{Dor::Config.assembly.cm_file_name} not found for #{druid.id} in any of the root directories: #{@root_dir.join(',')}" unless content_metadata_exists?
      @cm = Nokogiri.XML(File.open(cm_file_name)) { |conf| conf.default_xml.noblanks }
    end

    def load_stub_content_metadata
      # Loads stub content metadata XML into a Nokogiri document.
      path_to_object
      raise "Stub content metadata file #{Dor::Config.assembly.stub_cm_file_name} not found for #{druid.id} in any of the root directories: #{@root_dir.join(',')}" unless stub_content_metadata_exists?
      @stub_cm = Nokogiri.XML(File.open(stub_cm_file_name)) { |conf| conf.default_xml.noblanks }
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

    def create_basic_content_metadata
      raise "Content metadata file #{Dor::Config.assembly.cm_file_name} exists already" if content_metadata_exists?

      # get a list of files in content folder recursively and sort them
      files = Dir["#{path_to_content_folder}/**/*"].reject {|file| File.directory? file}.sort
      cm_resources = files.map { |file| Assembly::ObjectFile.new(file) }

      # uses the assembly-objectfile gem to create basic content metadata using a simple list of files found in the content folder
      xml = Assembly::ContentMetadata.create_content_metadata(druid: @druid.druid, style: :file, objects: cm_resources, bundle: :filename)
      @cm = Nokogiri.XML(xml)
      xml
    end

    def convert_stub_content_metadata
      # uses the assembly-objectfile gem to create content metadata using the stub contentMetadata provided
      load_stub_content_metadata

      cm_resources = resources.map do |resource| # loop over all resources from the stub content metadata
        resource_files(resource).map do |file| # loop over the files in this resource
          Assembly::ObjectFile.new(File.join(path_to_content_folder,filename(file)), file_attributes: file_attributes(file), label: resource_label(resource))
        end
      end

      xml = Assembly::ContentMetadata.create_content_metadata(druid: @druid.druid, style: gem_content_metadata_style, objects: cm_resources, bundle: :prebundled, add_file_attributes: true)
      @cm = Nokogiri.XML(xml)
      xml
    end

  end
end
