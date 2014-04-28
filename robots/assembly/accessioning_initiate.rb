module Robots
    module DorRepo
        module Assembly
            
            class AccessioningInitiate
                include LyberCore::Robot

                def initialize(opts = {})
                    super('assemblyWF', 'accessioning-initiate', opts)
                end
    
                def process_item(work_item)
                    ai = Dor::Assembly::Item.new :druid => work_item.druid
                    ai.initiate_accessioning
                end
    
            end
        end
    end

end
