module Robots
  module DorRepo
    module Assembly
  
      class ChecksumCompute 
        include LyberCore::Robot

        def initialize(opts = {})
          super('assemblyWF', 'checksum-compute', opts)
        end
    
        def perform(druid)
          ai = Dor::Assembly::Item.new :druid => druid      
          if (Dor::Config.configure.assembly.items_only && !ai.is_item?) 
             Assembly::ChecksumCompute.logger.warn("Skipping checksum-compute for #{druid} since it is not an item")
          else
            ai.load_content_metadata      
            ai.compute_checksums
          end
        end
    
      end
    end
  end
end
