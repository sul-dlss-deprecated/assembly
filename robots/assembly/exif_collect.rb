module Assembly
  
  class ExifCollect < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'exif-collect', opts)
    end

    def assembly_item(druid=nil)
      @ai ||= Dor::Assembly::Item.new :druid => druid
    end
    
    def process_item(work_item)
      druid=work_item.druid
      if (Dor::Config.configure.assembly.items_only && !assembly_item(druid).is_item?) 
         Assembly::ExifCollect.logger.info("Skipping exif-collect for #{druid} since it is not an item")
      else
        assembly_item(druid).load_content_metadata
        assembly_item(druid).collect_exif_info
      end
    end

  end

end
