module Assembly
  
  class AccessioningInitiate < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'accessioning-initiate', opts)
    end

    def assembly_item(druid)
      @ai ||= Dor::Assembly::Item.new :druid => druid
    end
    
    def process_item(work_item)
      druid=work_item.druid
      assembly_item(druid).initiate_accessioning 
    end
    
  end

end
