module Robots
  module DorRepo
    module Assembly

      class ExifCollect

        include LyberCore::Robot

        def initialize(opts = {})
          super('dor', 'assemblyWF', 'exif-collect', opts)
        end

        def perform(work_item)
          ai = Dor::Assembly::Item.new :druid => work_item.druid
          if (Dor::Config.configure.assembly.items_only && !ai.is_item?)
             Robots::DorRepo::Assembly::ExifCollect.logger.warn("Skipping exif-collect for #{work_item.druid} since it is not an item")
          else
            ai.load_content_metadata
            ai.collect_exif_info
          end
        end

      end
    end
  end
end
