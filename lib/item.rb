module Dor::Assembly

  class Item

    include Dor::Assembly::Checksumable
    include Dor::Assembly::ContentMetadata

    def initialize(params = {})
      @druid = params[:druid]
      setup
      load_content_metadata
    end

    def setup
      @druid        = Druid.new(@druid) unless @druid.class == Druid
      @root_dir     = Dor::Config.assembly.root
      @cm_file_name = File.join druid_tree_path, 'content_metadata.xml'
    end

  end
  
end
