module Dor::Assembly

  class Item

    include Dor::Assembly::Checksumable
    include Dor::Assembly::ContentMetadata

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
      @cm_handle = params[:cm_handle]
      @druid     = params[:druid]
      setup
    end

    def setup
      @root_dir       = Dor::Config.assembly.root
      @druid          = Druid.new(@druid) unless @druid.class == Druid
      @path           = File.join @root_dir, @druid.tree
      @cm_file_name   = File.join @path, 'content_metadata.xml'
      @cm             = load_content_metadata
      @checksums      = {}
      @checksum_types = [:md5, :sha1]
    end

    # TODO: Dor::Assembly::Item: methods below need specs.

    def load_content_metadata
      @cm = Nokogiri.XML(File.open @cm_file_name) { |conf| conf.default_xml.noblanks }
    end

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

    def persist_content_metadata
      @cm_handle ||= File.open(@cm_file_name, 'w')
      @cm_handle.puts @cm.to_xml
    end

  end
  
end

