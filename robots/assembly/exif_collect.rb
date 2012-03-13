module Assembly
  
  class ExifCollect < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'exif-collect', opts)
    end

    def process_item(work_item)
      @ai = Dor::Assembly::Item.new :druid => work_item.druid
      @ai.collect_exif_info
    end

  end

end
