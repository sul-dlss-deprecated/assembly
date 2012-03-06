module Dor::Assembly

  class Item

    include Dor::Assembly::Checksumable
    include Dor::Assembly::ContentMetadata
    include Dor::Assembly::Helper

    attr_accessor(
      :druid, 
      :root_dir, 
      :cm_file_name,
      :checksum_types
    )

    def initialize(params = {})
      @druid = params[:druid]
      setup
      load_content_metadata
    end

    def setup
      # TODO: setup(): @cm_file_type does not belong here.
      # TODO: setup(): @checksum_types does not belong here.
      @druid          = Druid.new(@druid) unless @druid.class == Druid
      @root_dir       = Dor::Config.assembly.root
      @cm_file_name   = File.join druid_tree_path, 'content_metadata.xml'
      @checksum_types = [:md5, :sha1]
    end

    # TODO: Dor::Assembly::Item: methods below need to be deleted or tested.

    def new_node(node_name)
      Nokogiri::XML::Node.new node_name, @cm
    end

    def file_path_of_node(node)
      File.join druid_tree_path, node['id']
    end

    def all_file_paths
      file_nodes.map { |n| file_path_of_node n }
    end

  end
  
end

