module Dor::Assembly

  class Item

    include Dor::Assembly::Checksumable
    include Dor::Assembly::ContentMetadata
    include Dor::Assembly::Helper

    attr_accessor :druid, :root_dir, :cm_file_name

    def initialize(params = {})
      @druid = params[:druid]
      setup
      load_content_metadata
    end

    def setup
      # TODO: setup(): @cm_file_type does not belong here.
      @druid        = Druid.new(@druid) unless @druid.class == Druid
      @root_dir     = Dor::Config.assembly.root
      @cm_file_name = File.join druid_tree_path, 'content_metadata.xml'
    end

  end
  
end

