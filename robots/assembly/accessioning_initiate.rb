module Robots
    module DorRepo
        module Assembly

            class AccessioningInitiate
                include LyberCore::Robot

                def initialize(opts = {})
                    super('dor', 'assemblyWF', 'accessioning-initiate', opts)
                end

                def perform(druid)
                    ai = Dor::Assembly::Item.new :druid => druid
                    ai.initiate_accessioning
                end

            end
        end
    end

end
