require_relative './base'

module Robots
    module DorRepo
        module Assembly

            class AccessioningInitiate < Robots::DorRepo::Assembly::Base
                def initialize(opts = {})
                    super('dor', 'assemblyWF', 'accessioning-initiate', opts)
                end

                def perform(druid)
                    ai = item(druid)
                    ai.initiate_accessioning
                end
            end
        end
    end
end
