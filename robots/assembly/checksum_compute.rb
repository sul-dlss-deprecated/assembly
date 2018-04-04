require_relative './base'

module Robots
  module DorRepo
    module Assembly
      class ChecksumCompute < Robots::DorRepo::Assembly::Base
        def initialize(opts = {})
          super('dor', 'assemblyWF', 'checksum-compute', opts)
        end

        def perform(druid)
          with_item(druid) do |ai|
            ai.compute_checksums
          end
        end
      end
    end
  end
end
