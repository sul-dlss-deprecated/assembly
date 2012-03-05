module Dor::Assembly

  class Item

    include Dor::Assembly::Checksumable
    include Dor::Assembly::ContentMetadata

    attr_accessor(
      :druid, 
      :root_dir, 
      :path,
      :cm_file_name,
      :checksums,
      :checksum_types
    )

    def initialize(params = {})
      @druid = params[:druid]
      setup
      load_content_metadata
    end

    def setup
      # TODO: setup(): should @cm_file_name be set in ContentMetadta.
      @druid          = Druid.new(@druid) unless @druid.class == Druid
      @root_dir       = Dor::Config.assembly.root
      @path           = File.join @root_dir, @druid.tree
      @cm_file_name   = File.join @path, 'content_metadata.xml'
      @checksums      = {}
      @checksum_types = [:md5, :sha1]
    end

    # TODO: Dor::Assembly::Item: methods below need to be deleted or tested.

    def new_node(node_name)
      Nokogiri::XML::Node.new node_name, @cm
    end

    def file_nodes
      @cm.xpath '//resource/file'
    end

    def file_path_of_node(node)
      File.join @path, node['id']
    end

    def all_file_paths
      file_nodes.map { |n| file_path_of_node n }
    end

  end
  
end

