module Assembly
  
  class Jp2Create < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'jp2-create', opts)
    end

    def assembly_item(druid=nil)
      @ai ||= Dor::Assembly::Item.new :druid => druid
    end
    
    def process_item(work_item)
      druid=work_item.druid
      if assembly_item(druid).is_item?
        assembly_item(druid).load_content_metadata
        assembly_item(druid).create_jp2s
      end
    end

  end

end
