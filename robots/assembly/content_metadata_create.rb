require_relative './base'

module Robots
  module DorRepo
    module Assembly
      class ContentMetadataCreate < Robots::DorRepo::Assembly::Base
        def initialize(opts = {})
          super('dor', 'assemblyWF', 'content-metadata-create', opts)
        end

        def perform(druid)
          item(druid).create_content_metadata
        end # end perform
      end # end class
    end # end Assembly module
  end # end DorRepo module
end # end Robots module
