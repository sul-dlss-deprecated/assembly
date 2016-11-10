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
          #TODO perhaps in the future, we can create some plain vanilla contentMetadata if neither actual or stub exists...but for now, that scenario
          #  will continue to cause a failure at the very next step in assemblyWF
          if !ai.is_item?
            return LyberCore::Robot::ReturnState.new(status: :skipped, note: 'object is not an item')
          elsif !ai.stub_content_metadata_exists?
            return LyberCore::Robot::ReturnState.new(status: :skipped, note: "#{Dor::Config.assembly.stub_cm_file_name} does not exist")
          elsif ai.content_metadata_exists?
            return LyberCore::Robot::ReturnState.new(status: :skipped, note: "#{Dor::Config.assembly.cm_file_name} already exists")
          else
            ai.create_content_metadata
            ai.persist_content_metadata
            return LyberCore::Robot::ReturnState.COMPLETED
          end
        end # end perform
        
      end # end class
      
    end # end Assembly module
  end # end DorRepo module
end # end Robots module
