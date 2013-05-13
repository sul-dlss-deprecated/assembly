module Assembly
  
  class ExifCollect < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'exif-collect', opts)
    end

    def assembly_item(druid)
      @ai ||= Dor::Assembly::Item.new :druid => druid
    end
    
    def process_item(work_item)
      ai = assembly_item(work_item.druid)
      if ai.is_item?
        ai.load_content_metadata
        ai.collect_exif_info
      end
    end

  end

end
