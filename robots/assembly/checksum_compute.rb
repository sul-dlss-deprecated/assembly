module Assembly
  
  class ChecksumCompute < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'checksum-compute', opts)
    end

    def assembly_item(druid=nil)
      @ai ||= Dor::Assembly::Item.new :druid => druid
    end
    
    def process_item(work_item)
      druid=work_item.druid
      if assembly_item(druid).is_item?
        assembly_item(druid).load_content_metadata      
        assembly_item(druid).compute_checksums
      end
    end
    
  end

end
