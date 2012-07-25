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

    # returns the location of a content file, which can be in the old location if not found in the new location    
    def content_file(filename)
      File.exists?(path_to_content_file(filename)) ? path_to_content_file(filename) : alt_path_to_file(filename)  
    end
    
    # returns the location of a metadata file, which can be in the old location if not found in the new location
    def metadata_file(filename)
      File.exists?(path_to_metadata_file(filename)) ? path_to_metadata_file(filename) : alt_path_to_file(filename)  
    end
    
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
    
    # new style druid tree path
    def druid_tree_path
      DruidTools::Druid.new(@druid.id,@root_dir).path()    
    end

    # new style path to a file
    def path_to_content_file(file_name)
      File.join druid_tree_path, "content", file_name
    end

    # new style path to a file
    def path_to_metadata_file(file_name)
      File.join druid_tree_path, "metadata", file_name
    end
    
    # parent of final druid tree path (which is the older style format)
    def parent_druid_tree_path
      Assembly::Utils.get_staging_path(@druid.id,@root_dir)
    end

    # old style path to a file
    def alt_path_to_file(file_name)
      File.join parent_druid_tree_path, file_name
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

  end
end

