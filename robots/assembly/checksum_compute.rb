module Assembly
  
  class ChecksumCompute < LyberCore::Robots::Robot

    def initialize(opts = {})
      super('assemblyWF', 'checksum-compute', opts)
    end
    
    def process_item(work_item)
      ai = Dor::Assembly::Item.new :druid => work_item.druid      
      if (Dor::Config.configure.assembly.items_only && !ai.is_item?) 
         Assembly::ChecksumCompute.logger.warn("Skipping checksum-compute for #{work_item.druid} since it is not an item")
      else
        ai.load_content_metadata      
        ai.compute_checksums
      end
    end
    
  end

end
