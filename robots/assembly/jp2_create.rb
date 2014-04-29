module Robots
  module DorRepo
    module Assembly

      class Jp2Create
        include LyberCore::Robot

        def initialize(opts = {})
          super('assemblyWF', 'jp2-create', opts)
        end

        def perform(druid)
          ai = Dor::Assembly::Item.new :druid => druid
          if (Dor::Config.configure.assembly.items_only && !ai.is_item?)
            Robots::DorRepo::Assembly::Jp2Create.logger.warn("Skipping JP2-create for #{druid} since it is not an item")
          else
            ai.load_content_metadata
            ai.create_jp2s
          end
        end

      end
    end
  end
end
