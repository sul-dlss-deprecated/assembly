require_relative './base'
require 'dor/services/client'

module Robots
  module DorRepo
    module Assembly
      class AccessioningInitiate < Robots::DorRepo::Assembly::Base
        def initialize(opts = {})
          super('dor', 'assemblyWF', 'accessioning-initiate', opts)
        end

        def perform(druid)
          @ai = item(druid)
          LyberCore::Log.info("Inititate accessioning for #{@ai.druid.id}")
          initialize_workspace if @ai.is_item?
          initialize_workflow
          true
        end

        private

        def initialize_workspace
          Dor::Services::Client.initialize_workspace(object: @ai.druid.druid,
                                                     source: @ai.path_to_object)
        end

        def initialize_workflow
          Dor::Services::Client.initialize_workflow(object: @ai.druid.druid,
                                                    wf_name: 'accessionWF')
        end
      end
    end
  end
end
