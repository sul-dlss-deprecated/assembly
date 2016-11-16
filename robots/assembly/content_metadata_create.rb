require_relative './base'

module Robots
  module DorRepo
    module Assembly
      class ContentMetadataCreate < Robots::DorRepo::Assembly::Base
        def initialize(opts = {})
          super('dor', 'assemblyWF', 'content-metadata-create', opts)
        end

        def perform(druid)
          ai = item(druid)
          return LyberCore::Robot::ReturnState.new(status: :skipped, note: 'object is not an item') unless ai.is_item? # not an item, skip

          if ai.stub_content_metadata_exists? && ai.content_metadata_exists? # both stub and regular content metadata exist -- this is an ambiguous situation and generates an error
            return LyberCore::Robot::ReturnState.new(status: :skipped, note: "#{Dor::Config.assembly.stub_cm_file_name} and #{Dor::Config.assembly.cm_file_name} both exist")
          end

          if ai.content_metadata_exists? # regular content metadata exists -- do not recreate it
            return LyberCore::Robot::ReturnState.new(status: :skipped, note: "#{Dor::Config.assembly.cm_file_name} exists")
          end

          # if stub exists, create metadata from the stub, else create basic content metadata
          ai.stub_content_metadata_exists? ? ai.convert_stub_content_metadata : ai.create_basic_content_metadata
          ai.persist_content_metadata
          LyberCore::Robot::ReturnState.COMPLETED
        end # end perform
      end # end class
    end # end Assembly module
  end # end DorRepo module
end # end Robots module
