module Dor::Assembly

  class Item

    include Dor::Assembly::ContentMetadata

    include Dor::Assembly::Jp2able
    include Dor::Assembly::Checksumable
    include Dor::Assembly::ChecksumComparable
    include Dor::Assembly::Exifable
    include Dor::Assembly::Accessionable

    def initialize(params = {})
      # Takes a druid, either as a string or as a Druid object.
      # Always converts @druid to a Druid object.
      @druid = params[:druid]
      setup
      load_content_metadata
    end

    def setup
      @druid        = Druid.new(@druid) unless @druid.class == Druid
      @root_dir     = Dor::Config.assembly.root_dir
      cmf           = Dor::Config.assembly.cm_file_name 
      @cm_file_name = path_to_file cmf
    end

  end
  
end
