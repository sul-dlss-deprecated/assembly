module Robots
  module DorRepo
    module Assembly

      class ExifCollect

        # Build off the base robot implementation which implements
        # features common to all robots
        include LyberCore::Robot

        def initialize(opts = {})
          super('dor', 'assemblyWF', 'exif-collect', opts)
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          ai = Dor::Assembly::Item.new :druid => druid
          if (Dor::Config.configure.assembly.items_only && !ai.is_item?)
             Robots::DorRepo::Assembly::ExifCollect.logger.warn("Skipping exif-collect for #{druid} since it is not an item")
          else
            ai.load_content_metadata
            ai.collect_exif_info
          end
        end

      end
    end
  end
end
