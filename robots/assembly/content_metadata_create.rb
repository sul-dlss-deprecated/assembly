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
          if !ai.is_item? # not an item, skip
            return LyberCore::Robot::ReturnState.new(status: :skipped, note: 'object is not an item')
          elsif ai.stub_content_metadata_exists? && ai.content_metadata_exists? # both stub and regular content metadata exist -- this is an ambiguous situation and generates an error
            return LyberCore::Robot::ReturnState.new(status: :skipped, note: "#{Dor::Config.assembly.stub_cm_file_name} and #{Dor::Config.assembly.cm_file_name} both exist")
          elsif ai.stub_content_metadata_exists? && !ai.content_metadata_exists? # stub exists but not regular content metadata, create it from the stub
            ai.convert_stub_content_metadata
          else # if we get this far, we do not have stub or regular content metadata, so create basic content metadata
            ai.create_basic_content_metadata
          end
          ai.persist_content_metadata
          return LyberCore::Robot::ReturnState.COMPLETED
        end # end perform
        
      end # end class
      
    end # end Assembly module
  end # end DorRepo module
end # end Robots module
