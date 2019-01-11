require_relative './base'

module Robots
  module DorRepo
    module Assembly
      class ExifCollect < Robots::DorRepo::Assembly::Base
        def initialize(opts = {})
          super('dor', 'assemblyWF', 'exif-collect', opts)
        end

        def perform(druid)
          with_item(druid, &:collect_exif_info)
        end
      end
    end
  end
end
