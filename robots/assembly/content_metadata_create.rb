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
          if ai.stub_content_metadata_exists? && !ai.content_metadata_exists? # if we have a stub and no actualContentMetadata, try and create it
            ai.create_content_metadata
            ai.persist_content_metadata
          else # else mark the step as skipped
            # TODO mark step as skipped
          end
        end

      end
    end
  end
end
