module Robots
    module DorRepo
        module Assembly

            class AccessioningInitiate
                # Build off the base robot implementation which implements
                # features common to all robots
                include LyberCore::Robot

                def initialize(opts = {})
                    super('dor', 'assemblyWF', 'accessioning-initiate', opts)
                end

                # `perform` is the main entry point for the robot. This is where
                # all of the robot's work is done.
                #
                # @param [String] druid -- the Druid identifier for the object to process
                def perform(druid)
                    ai = Dor::Assembly::Item.new :druid => druid
                    ai.initiate_accessioning
                end

            end
        end
    end

end
