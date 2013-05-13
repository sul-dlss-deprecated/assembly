module Assembly
  
  class Jp2Create < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'jp2-create', opts)
    end

    def assembly_item(druid)
      @ai ||= Dor::Assembly::Item.new :druid => druid
    end
    
    def process_item(work_item)
      ai = assembly_item(work_item.druid)      
      if ai.is_item?
        ai.load_content_metadata
        ai.create_jp2s
      end
    end

  end

end
