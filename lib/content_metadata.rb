require 'assembly-objectfile'

module Dor::Assembly
  module ContentMetadata

    attr_accessor(
      :cm,
      :cm_file_name,
      :cm_handle,
      :druid,
      :root_dir
    )
        
    def load_content_metadata
      # Loads content metadata XML into a Nokogiri document.
      @cm = Nokogiri.XML(File.open @cm_file_name) { |conf| conf.default_xml.noblanks }
    end

    def persist_content_metadata
      # Writes content metadata XML to the content metadata file or
      # to @cm_handle (the latter is used for testing purposes).
      xml = @cm.to_xml
      if @cm_handle
        @cm_handle.puts xml
      else
        File.open(@cm_file_name, 'w') { |f| f.puts xml }
      end
    end

    def new_node_in_cm(node_name)
      # Returns a new node with the supplied name (with the GC lifecycle of
      # the content metadata document).
      Nokogiri::XML::Node.new node_name, @cm
    end

    def druid_tree_path
      File.join @root_dir, @druid.path
    end

    def path_to_file(file_name)
      File.join druid_tree_path, file_name
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
      file_nodes(resource_type).map { |fn| [ fn, Assembly::ObjectFile.new(path_to_file fn['id']) ] }
    end

  end
end

