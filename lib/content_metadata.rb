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
      @cm = Nokogiri.XML(File.open @cm_file_name) { |conf| conf.default_xml.noblanks }
    end

    def persist_content_metadata
      xml = @cm.to_xml
      if @cm_handle
        @cm_handle.puts xml
      elsif
        File.open(@cm_file_name, 'w') { |f| f.puts xml }
      end
    end

    def new_node_in_cm(node_name)
      Nokogiri::XML::Node.new node_name, @cm
    end

    def druid_tree_path
      # TODO: spec.
      File.join @root_dir, @druid.path
    end

    def file_nodes
      # TODO: spec.
      @cm.xpath '//resource/file'
    end

  end
end

