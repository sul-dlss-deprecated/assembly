module Dor::Assembly

  class Item

    include Dor::Assembly::ContentMetadata
    include Dor::Assembly::Checksumable
    include Dor::Assembly::ChecksumComparable

    def initialize(params = {})
      @druid = params[:druid]
      setup
      load_content_metadata
    end

    def setup
      @druid        = Druid.new(@druid) unless @druid.class == Druid
      @root_dir     = Dor::Config.assembly.root_dir
      cmf           = Dor::Config.assembly.cm_file_name 
      @cm_file_name = File.join druid_tree_path, cmf
    end

  end
  
end
