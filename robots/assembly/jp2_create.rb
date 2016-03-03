require_relative './base'

module Robots
  module DorRepo
    module Assembly

      class Jp2Create < Robots::DorRepo::Assembly::Base
        def initialize(opts = {})
          super('dor', 'assemblyWF', 'jp2-create', opts)
        end

        def perform(druid)
          with_item(druid) do |ai|
            ai.create_jp2s
          end
        end

      end
    end
  end
end
