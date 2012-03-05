module Dor

  class AssemblyItem

    include Dor::Checksumable

    attr_accessor(
      :root_dir, 
      :cm_handle,
      :druid, 
      :path,
      :cm_file_name,
      :cm,
      :checksums,
      :checksum_types
    )

    def initialize(params = {})
      @root_dir  = params[:root_dir]
      @cm_handle = params[:cm_handle]
      @druid     = params[:druid]
      setup
    end

    def setup
      @druid          = Druid.new(@druid) unless @druid.class == Druid
      @path           = File.join @root_dir, @druid.tree
      @cm_file_name   = File.join @path, 'content_metadata.xml'
      @cm             = load_content_metadata
      @checksums      = {}
      @checksum_types = [:md5, :sha1]
    end

    # TODO: AssemblyItem: several new methods need specs.

    def load_content_metadata
      Nokogiri::XML(File.open @cm_file_name)
    end

    def new_node(node_name)
      Nokogiri::XML::Node.new node_name, @cm
    end

    def file_nodes
      @cm.css 'resource file'
    end

    def file_path_of_node(node)
      File.join @path, node['id']
    end

    def all_file_paths
      file_nodes.map { |n| file_path_of_node n }
    end

    def persist_content_metadata
      # TODO: persist_content_metadata(): in test_input, remove whitespace from XML.
      @cm_handle ||= File.open @cm_file_name, 'w'
      @cm_handle.puts @cm
    end

  end
  
end

