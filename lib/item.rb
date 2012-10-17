module Dor::Assembly

  class Item

    include Dor::Assembly::ContentMetadata
    include Dor::Assembly::Jp2able
    include Dor::Assembly::Checksumable
    include Dor::Assembly::Exifable
    include Dor::Assembly::Accessionable
    include Dor::Assembly::Findable

    def initialize(params = {})
      # Takes a druid, either as a string or as a Druid object.
      # Always converts @druid to a Druid object.
      @druid = params[:druid]
      setup
      raise "Path to object #{@druid.id} not found in any of the root directories: #{@root_dir.join(',')}" if path_to_object == nil
      load_content_metadata
    end

    def setup
      @druid        = DruidTools::Druid.new(@druid) unless @druid.class == DruidTools::Druid
      root_dir_config = Dor::Config.assembly.root_dir
      @root_dir = root_dir_config.class == String ? [root_dir_config] : root_dir_config  # this allows us to accept either a string or an array of strings as an root dir configuration
    end

  end
  
end
